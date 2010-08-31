Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178Ab0HaGtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 02:49:14 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:37771 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab0HaGtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 02:49:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Ll/6qMWeAOK0eT+owdpZKnaWtBTUi9+aFZMfJHpCoHBE/r8DPdtCnuOFmWFL9KVqtG
         tUnHY6ICxL8dVPNXyL0pFN7z09mNS+FB4/OPwOkzr0VKON1FIvjC0C8CQq8fy/pH0QTf
         l37tYuPG+R7OELKDxB99i7X73CqeU5ld7jl4c=
MIME-Version: 1.0
Date: Tue, 31 Aug 2010 12:19:12 +0530
Message-ID: <AANLkTimWnYqFSC=3kqzBVtZHwodCX=MnsViDGmJbUn_8@mail.gmail.com>
Subject: increasing memory alloted for 'init' during kernel boot.
From: Prabhu Chawandi <prabhu.chavandi@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

   Whenever the kernel starts booting, I am getting the bellow log :

Memory: 110080k/262144k available (2566k kernel code, 151952k
reserved, 561k data, 15328k init, 0k highmem).

For 'init' on what bases this amount of memory is decided ?

Anyways I can alter it?

Thanks in advance,
Prabhu
