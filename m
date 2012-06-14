Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab2FNJEE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 05:04:04 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:60472 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753073Ab2FNJEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 05:04:01 -0400
Message-ID: <4FD9A8FB.6020507@mev.co.uk>
Date: Thu, 14 Jun 2012 10:03:55 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (Windows NT 5.2; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 12/15] staging: comedi: 8255: refactor subdev_8255_insn
 function
References: <201206131542.46112.hartleys@visionengravers.com>
In-Reply-To: <201206131542.46112.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/06/13 11:42 PM, H Hartley Sweeten wrote:
> Refactor the subdev_8255_insn function to follow what the user
> space library is doing.
> 
> 1) This function requires 'data' to contain 2 parameters. Add a
> sanity check for this (insn->n != 2).

Actually, the comedi core will have already checked that.

> 4) The user space library only checks for a < 0 return to indicate
> an error. It appears that the 'return 2' in this function is supposed
> to indicate the number of data parameters used to perform the command.
> Return the insn->n value for this, the open coded '2' looks wrong.

As long as it still returns 2, I don't care how you do it!

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>             )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587              )=-
