Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965558Ab2JaN4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 09:56:53 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41599 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965482Ab2JaN4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 09:56:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAE8XmWo5YDu7iBVKH5Z2_EeAAePia24zwtfgPFJ0Cfxjz8Avwg@mail.gmail.com>
References: <20121030162004.GA3467@Super-MAGI>
	<CAE8XmWo5YDu7iBVKH5Z2_EeAAePia24zwtfgPFJ0Cfxjz8Avwg@mail.gmail.com>
Date: Wed, 31 Oct 2012 21:56:48 +0800
Message-ID: <CA+HMz3gBWkZVq+pcOqX5yrccGHiRw6NqJY7P5d+T_ir=Qzj_9Q@mail.gmail.com>
Subject: Re: [PATCH]Documentation: Chinese translation of Documentation/arm/kernel_user_helpers.txt
From: Ninja Tekkaman <tekkamanninja@gmail.com>
To: Dongsheng Song <dongsheng.song@gmail.com>
Cc: Harry Wei <harryxiyou@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Dave Martin <dave.martin@linaro.org>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9VDuwer018672

Hi, Dongsheng
Thanks for your help!
I will make a new one ,and add your name.

在 2012年10月31日 下午1:06，Dongsheng Song <dongsheng.song@gmail.com> 写道：
> Hi,
>
> There have some misleading in the translation:
>
> -------------------------------- origin  --------------------------------
> User space is expected to bypass those helpers and implement those things
> inline (either in the code emitted directly by the compiler, or part of
> the implementation of a library call) when optimizing for a recent enough
> processor that has the necessary native support, but only if resulting
> binaries are already to be incompatible with earlier ARM processors due to
> usage of similar native instructions for other things.  In other words
> don't make binaries unable to run on earlier processors just for the sake
> of not using these kernel helpers if your compiled code is not going to
> use new instructions for other purpose.
>
> -------------------------------- Fu Wei  --------------------------------
> 当对那些拥有基本原生支持的新型处理器的代码进行优化时，用户空间最好绕
> 过这些辅助代码并在内联函数中实现这些操作（无论是通过编译器在代码中直
> 接放置，还是作为库函数调用实现的一部分），而仅在其他处理器因使用相似
> 的本地指令而导致二进制结果已与早期 ARM 处理不兼容的情况下才使用这些
> 辅助代码。也就是说，如果你编译的代码不会为了其他目的使用新的指令，则
> 不要仅为了不使用这些内核辅助代码而导致二进制程序无法在早期处理器上运
> 行。
> -------------------------------- me  --------------------------------
> 当对那些拥有原生支持的新型处理器进行代码优化时，如果已经在其它代码中
> 使用类似的新指令，从而导致二进制结果已与早期 ARM 处理器不兼容的情况下，
> 用户空间最好绕过这些辅助代码，并在内联函数中实现这些操作（无论是通过
> 编译器在代码中直接发出，还是作为库函数调用实现的一部分）。也就是说，
> 如果你编译的代码不会为了其他目的使用新指令，则不要仅为了不使用这些内核
> 辅助代码，导致二进制程序无法在早期处理器上运行。
>
> The attachment is my review result.
>
> --
> Dongsheng
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
