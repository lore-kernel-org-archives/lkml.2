Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab1LLR2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:28:18 -0500
Received: from billgribble.com ([65.99.215.30]:59180 "EHLO
	mail.billgribble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642Ab1LLR2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:28:15 -0500
Message-ID: <1323710873.3638.2.camel@debian.lii>
Subject: Re: Mystery clicking under keyboard, 3.x only, SSD only
From: Bill Gribble <grib@billgribble.com>
To: "Alexander E. Patrakov" <patrakov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 12 Dec 2011 12:27:53 -0500
In-Reply-To: <4EE635A2.8080705@gmail.com>
References: <20111211142451.63febb26@pequin> <4EE635A2.8080705@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3-3+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-12 at 23:10 +0600, Alexander E. Patrakov wrote:
> This clicking can be related to the events when the device goes to deep 
> powersaving levels. Fluctuations in the consumed current can lead to 
> audible clicks due to bad screening of audio wires, loose ferrite cores 
> in the coils, magnetostriction effect, etc.
> 
> You can test this theory by running several copies of "yes > /dev/null" 
> and thus eating 100% CPU. If this eliminates the clicking effect, then 
> my guess is correct and you have to disable some of the deepest 
> powersaving states to remove the clicks.

Got it in one!  Causing 100% CPU utilization does indeed stop the
clicking.  I will look for power saving settings that I can control. 

Thanks,
Bill Gribble


