Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab2FTCHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 22:07:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62311 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab2FTCHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 22:07:15 -0400
Date: Tue, 19 Jun 2012 19:03:59 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>,
        "Tc, Jenny" <jenny.tc@intel.com>
Subject: Re: [PATCH v2] charger_manager: update charge profile upon
 temperature zone change
Message-ID: <20120620020359.GA14363@lizard>
References: <1336413485-4585-1-git-send-email-ramakrishna.pallala@intel.com>
 <20120619235022.GA12508@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120619235022.GA12508@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 04:50:22PM -0700, Anton Vorontsov wrote:
> On Mon, May 07, 2012 at 11:28:05PM +0530, Ramakrishna Pallala wrote:
> > Battery vendors like UER suggest to program Low Charge Voltage in case
> > of high or low temperatures. So a battery can have different charge profile
> > with in the battery operating temperature limits.
> > 
> > Next, there could be events like drop or rise in VBUS voltage in that case
> > we might have to adjust the charge current to stabilize VBUS voltage.
> > 
> > This patch allows the Charger-Manager to adjust the charging parameters
> > upon events like VBUS rise or drop and allows batteries to have multiple
> > charge profiles for different temperature zones.
> > 
> > Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
> > ---
> 
> Applied, thanks a lot!

Oh, actually. I see the feature is still under discussion. I really
need some kind of OK/Ack from charger-manager folks before applying.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
