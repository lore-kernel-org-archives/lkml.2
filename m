Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab2KMMxO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 07:53:14 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33021 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046Ab2KMMxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 07:53:12 -0500
MIME-Version: 1.0
In-Reply-To: <CAD+1EGP8RjgBgfQ9oHSU3RdRnSbeOGJTpvkN_UWtNszWpvtd1w@mail.gmail.com>
References: <20121109164426.GA3799@Super-MAGI> <CAD+1EGP8RjgBgfQ9oHSU3RdRnSbeOGJTpvkN_UWtNszWpvtd1w@mail.gmail.com>
From: Dongsheng Song <dongsheng.song@gmail.com>
Date: Tue, 13 Nov 2012 20:52:51 +0800
Message-ID: <CAE8XmWp8HgK4p2i4+PkD60yY-xcTbTz43sUDHi-8-1_wTGLNUg@mail.gmail.com>
Subject: Re: [PATCH v2]Documentation: Chinese translation of Documentation/arm/kernel_user_helpers.txt
To: Tekkaman Ninja <tekkamanninja@gmail.com>
Cc: harryxiyou <harryxiyou@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Dave Martin <dave.martin@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qADCrHD0015037

Hi,

Here is the original text:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=Documentation/arm/kernel_user_helpers.txt;h=5673594717cfcfe798d87ae95b7e5a1d386aeaff;hb=HEAD

  23 User space is expected to bypass those helpers and implement those things
  24 inline (either in the code emitted directly by the compiler, or part of
  25 the implementation of a library call) when optimizing for a recent enough
  26 processor that has the necessary native support, but only if resulting
  27 binaries are already to be incompatible with earlier ARM processors due to
  28 usage of similar native instructions for other things.

+在对那些拥有原生支持的新型处理器进行代码优化时，用户空间最好绕过这些
+辅助代码，并在内联函数中实现这些操作（无论是通过编译器在代码中直接放置，
+还是作为库函数调用实现的一部分）；仅有在为了其他操作使用了同类原生指令，
+导致二进制结果已与早期 ARM 处理不兼容的情况下，才使用这些辅助代码。

My review is:

当对那些拥有原生支持的新型处理器进行代码优化时，如果已经在其它代码中
使用类似的新指令，从而导致二进制结果已与早期 ARM 处理器不兼容的情况下，
用户空间最好绕过这些辅助代码，并在内联函数中实现这些操作（无论是通过
编译器在代码中直接发出，还是作为库函数调用实现的一部分）。

Why do you revert my translation ? The new translation looks wrong too.

Regards,
Dongsheng
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
