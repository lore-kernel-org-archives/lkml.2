Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab1BGNYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 08:24:19 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50996 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab1BGNYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 08:24:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=ippJQ8Zg9sQpLBui0MDYz5oLN6NAl9bDSRXkMqeVkbO6geY8Rv7y1DG1slnynfXBFO
         BtpNZYhiPd3qL8mH0GekW2AxUmrwIPu0Srtme8L2QxqS7D7xLzPOFdbPj0Yqpse1Izv0
         O8da9E2CrIvxj8BRFq8GtEvSHoXgjcx3BOMLc=
Date: Mon, 7 Feb 2011 21:24:15 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH]Translated linux-2.6/Documentation/magic-number.txt
 into Chinese
Message-ID: <20110207132414.GA2162@gmail.com>
References: <20110207075809.GA16214@gmail.com>
 <4D4FB3BE.1040203@tao.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D4FB3BE.1040203@tao.ma>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 07, 2011 at 04:56:30PM +0800, Tao Ma wrote:
> On 02/07/2011 03:58 PM, Harry Wei wrote:
> >Hi us,
> >    I have translated linux-2.6/Documentation/magic-number.txt into Chinese.
> >When i paste the patch into my mutt, something wrong happened, which i can not close this mail. The mutt shows something wrong about /tmp/...
> >    So i have to add an accessory including my patcher. If you don't want to download it, you can also click the URL: http://harrywei.org/blog/?p=46
> >for it.
> Please try git send-email so that we can reply to it directly.
> 
> The following small comment is in chinese.
> 你是自己翻译的，还是使用了类似google翻译一类的软件？
> 很抱歉我提出这样的问题，但是请看这一句：
> The tty code, for example, does this frequently to pass
> driver-specific and line discipline-specific structures back and
> forth.
Hi Tao, Greg
	I think everyone can not translated a sentence in the same way. So it is right that you have the different idea. I have seen your translation of that sentence, which is better than mine. So i consider you should patch it for us. Linux kernel is stronger by this way(find bugs and patch for them), isn't it?
	Maybe you have other thoughts, send to us. We can talk then be stronger :)
	I have correct this sentence in your way then patch it again.
	So thanks for your help.

	Best Regards.
	Harry Wei.
> 你的翻译是：
> 
> tty源码，例如，经常通过特定驱动使用这种方法并且反复地排列特定方面的结构。
> 
> “例如”在中文中很少有这么用的吧？ 而且似乎应该翻译成
> 
> 例如tty的代码中就经常使用这种方法来传递一些驱动相关或者线路特性相关的数据结构。
> 你的翻译我实在是无法读懂，谢谢！
> 
> Regards,
> Tao
> 
> 
> 
> 
> 
