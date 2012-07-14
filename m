Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432Ab2GNICz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 04:02:55 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:58259 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157Ab2GNICv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 04:02:51 -0400
MIME-Version: 1.0
Date: Sat, 14 Jul 2012 13:47:50 +0545
Message-ID: <CAHdPZaP82=n_BqBNCEZDfGUDL+VpGO4hhy+ifDTpK6E9C9n+=Q@mail.gmail.com>
Subject: Q: free up of memory allocated with the devm_kzalloc if driver probe fails
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


     manual page of devm_kzalloc says that "the memory allocated with
this function is freed automatically at driver detach".
     Say for example driver probe failed, will the memory be freed up?
as driver's remove callback will not be called since probe failed.

Thanks,
Devendra
