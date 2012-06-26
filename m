Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab2FZIvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 04:51:48 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:60574 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753547Ab2FZIvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 04:51:47 -0400
Message-ID: <4FE9781D.9000500@mev.co.uk>
Date: Tue, 26 Jun 2012 09:51:41 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 07/33] staging: comedi: cb_das16_cs: remove some useless
 comments
References: <201206251610.38013.hartleys@visionengravers.com>
In-Reply-To: <201206251610.38013.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-06-26 00:10, H Hartley Sweeten wrote:
> --- a/drivers/staging/comedi/drivers/cb_das16_cs.c
> +++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
> @@ -19,6 +19,13 @@
>       along with this program; if not, write to the Free Software
>       Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>
> +    PCMCIA support code for the is adapted from the dummy_cs.c driver
> +    of the Linux PCMCIA Card Services package.

That sentence no sense!  But the original sentence it was moved from was 
wrong in a different way.  I suggest starting it with "PCMCIA support 
code for this driver ..."

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
