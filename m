Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab2DPOEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 10:04:47 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:49605 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753314Ab2DPOEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 10:04:46 -0400
Date: Mon, 16 Apr 2012 10:04:43 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Russell Whitaker <russ@ashlandhome.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: default framebuffer
Message-ID: <20120416140443.GA1153@elliptictech.com>
References: <alpine.LNX.2.00.1204152129060.2200@bigred.russwhit.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1204152129060.2200@bigred.russwhit.org>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On 2012-04-15 21:37 -0700, Russell Whitaker wrote:
> Trying out kernel 3.2.13
> 
> When it boots, it starts out with 80x25 screen.
> Then the framebuffer kicks in and I get a 60 line screen.
> 
> My eye-sight is not so good anymore, so I need a magnifing glass to read 
> that small print.
> 
> What should I do to keep the screen at 80x25?

Load a bigger console font.  For example, the Terminus font package
http://terminus-font.sourceforge.net/ includes some nice console fonts
in a variety of sizes.  Try

  setfont ter-132b

to start.  Your distribution probably provides a convenient way to set
the console font at boot.

Hope that helps,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

