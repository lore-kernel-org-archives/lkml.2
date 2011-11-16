Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab1KPLDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 06:03:36 -0500
Received: from phobos.b-et-a.de ([80.237.154.114]:40981 "HELO un.b-et-a.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756004Ab1KPLDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 06:03:35 -0500
Date: Wed, 16 Nov 2011 12:03:30 +0100
From: Klaus Ripke <klaus@ripke.com>
To: linux-kernel@vger.kernel.org
Cc: Clemens Ladisch <clemens@ladisch.de>
Subject: Re: LOAD_FREQ (4*HZ+61) avoids loadavg Moire
Message-ID: <20111116110330.GA235@aine.Speedport_W_502V_Typ_A>
References: <20111112143825.GX6192@aine.Speedport_W_502V_Typ_A> <4EC0CD04.4090107@ladisch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC0CD04.4090107@ladisch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 14, 2011 at 09:10:44AM +0100, Clemens Ladisch wrote:
> Klaus Ripke wrote:
> > With some seconds based load (like SSL heartbeats)
> > and LOAD_FREQ at (5*HZ+1) I see Moire patterns like inverse sawtooth,
> 
> Thanks for researching this, but I don't see them because I'm too lazy
> to reproduce this.  Could you please publish a colorful screenshot
> somewhere?

there you go http://ripke.com/loadavg/moire


best
