Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518Ab1DMUGD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 16:06:03 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37644 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758409Ab1DMUGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 16:06:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=erNGPX2HtskAV0o0PAumzEXiqW1CpRbhytpIWkIm9+MYdzE0TFPmBXcDJnGmBz5oUQ
         zbDhhuq3/BUi3qzrIJ6MvChlf6y/xJ7Gk9PCIQpwBMhv1bcXy7Vsbh/KwbzkkgVmDKpW
         vSNg465PpWE65eVNTiqK0yxffA+ZpUVXIxx/w=
MIME-Version: 1.0
Date: Wed, 13 Apr 2011 15:05:59 -0500
Message-ID: <BANLkTikAqz5xBRfpxBuwxVujE--Qam2FsQ@mail.gmail.com>
Subject: Disable PCI while CONFIG_PCI=y
From: Xianghua Xiao <xiaoxianghua@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is it possible to do something like 'pci=off' to have the same effect
as turning of CONFIG_PCI during menuconfig?
I want to build one image for both PCIE RC and PCIE EP(endpoint), for
EP I do not need PCI to be enabled at all.

looking at drivers/pci/pci.c I don't see such option exists, am I
missing something?

Thanks,
Xianghua
