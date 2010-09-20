Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab0ITIDm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 04:03:42 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39038 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab0ITIDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 04:03:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=wiyGa4emUrJCgGTcua6+gbWmMyOuXy3bSGBO4R/kR2KPqcPwcFHYWi+i1FFsdIwc+9
         z2fb+s8uEfm/i6u9Ny8QzGm4LhCwJXJaHhexnXTysMliem4acodpZTKMRBTbcOmL0qBg
         KNHz+lIxKS99QsbfeTxEuzzRlBLKeA+J3Cd0E=
MIME-Version: 1.0
Date: Mon, 20 Sep 2010 16:03:40 +0800
Message-ID: <AANLkTinJBUxr-GtxxMFsnn_tb-0FS9b1KOe06YiBr5En@mail.gmail.com>
Subject: Is it supported to perf probe data?
From: Luming Yu <luming.yu@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: masami.hiramatsu@hds.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

I need to analyze accessing pattern to a data in kernel. Wanna to
check with you if perf probe can help to get that trace.

Thanks,
Luming
