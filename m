Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab2LCBci (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 20:32:38 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64678 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374Ab2LCBch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 20:32:37 -0500
Date: Sun, 2 Dec 2012 17:29:16 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: "Tc, Jenny" <jenny.tc@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        anish kumar <anish198519851985@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Subject: Re: [PATCH] EXTCON: Get and set cable properties
Message-ID: <20121203012916.GA7330@lizard.sbx05977.paloaca.wayport.net>
References: <1354052956-3394-1-git-send-email-jenny.tc@intel.com>
 <20ADAB092842284E95860F279283C564E2754F@BGSMSX101.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20ADAB092842284E95860F279283C564E2754F@BGSMSX101.gar.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 02, 2012 at 06:53:17AM +0000, Tc, Jenny wrote:
> Could you please review this. This is a follow up patch for "PATCH]
> extcon : callback function to read cable property"

While I see nothing wrong with the patch itself, I beg you to send some
users for the new calls. Don't be obsessed with the extcon internals too
much, think more about how things will interact (i.e. I really really want
to see how you use these calls from the power supply drivers).

Thanks,
Anton.
