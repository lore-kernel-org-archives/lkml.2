Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab1BGI4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 03:56:39 -0500
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:52236 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752693Ab1BGI4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 03:56:38 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=L70OwuLHJ3G3ctiuxMBY+St0QKOHDZsrQmqMUGPUQtWntOd5vtxhNxpNKGyDxFl24hLBXgA+TQxNumi4Dq0/yssYvGefaFoa9IY7XjdhQNExG3oeKYDsfOwl/+9mDbf/;
Message-ID: <4D4FB3BE.1040203@tao.ma>
Date: Mon, 07 Feb 2011 16:56:30 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, greg@kroah.com,
        "jiaweiwei.xiyou@gmail.com >> Harry Wei" <jiaweiwei.xiyou@gmail.com>
Subject: Re: [PATCH]Translated linux-2.6/Documentation/magic-number.txt into
 Chinese
References: <20110207075809.GA16214@gmail.com>
In-Reply-To: <20110207075809.GA16214@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 221.217.46.20 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2011 03:58 PM, Harry Wei wrote:
> Hi us,
>     I have translated linux-2.6/Documentation/magic-number.txt into Chinese.
> When i paste the patch into my mutt, something wrong happened, which i can not close this mail. The mutt shows something wrong about /tmp/...
>     So i have to add an accessory including my patcher. If you don't want to download it, you can also click the URL: http://harrywei.org/blog/?p=46
> for it.
>    
Please try git send-email so that we can reply to it directly.

The following small comment is in chinese.
你是自己翻译的，还是使用了类似google翻译一类的软件？
很抱歉我提出这样的问题，但是请看这一句：
The tty code, for example, does this frequently to pass driver-specific 
and line discipline-specific structures back and forth.
你的翻译是：

tty源码，例如，经常通过特定驱动使用这种方法并且反复地排列特定方面的结构。

“例如”在中文中很少有这么用的吧？ 而且似乎应该翻译成

例如tty的代码中就经常使用这种方法来传递一些驱动相关或者线路特性相关的数据结构。
你的翻译我实在是无法读懂，谢谢！

Regards,
Tao





