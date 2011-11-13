Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab1KMPKL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 10:10:11 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48308 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab1KMPKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 10:10:09 -0500
MIME-Version: 1.0
In-Reply-To: <CALKntY2A5AAc0r87rX64yQEBZZTjhra=SQk9qnjKPRZJPF6s8w@mail.gmail.com>
References: <CALKntY2A5AAc0r87rX64yQEBZZTjhra=SQk9qnjKPRZJPF6s8w@mail.gmail.com>
Date: Sun, 13 Nov 2011 23:10:09 +0800
Message-ID: <CAM_iQpX0sM=8O911nVba_JZ0VVJ_sxTquFfixYjgkJ7TAJFmcw@mail.gmail.com>
Subject: Re: module_init in linux kernel
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Xin Tong <xerox.time.tech@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 13, 2011 at 8:11 PM, Xin Tong <xerox.time.tech@gmail.com> wrote:
> When one is writing a module, are module_init and module_exit
> mandatory. I understand that module_init and module_exit are just
> macro which place functions in special .text area. Is there is not
> module_init or module_exit defined, is there any default to take over
> or the kernel will panic when the module is loaded.
>

It is valid to write a kernel module without module_init().
