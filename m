Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab2AYKU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 05:20:29 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53705 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab2AYKU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 05:20:27 -0500
MIME-Version: 1.0
In-Reply-To: <CAEmTpZHkKB29FLWqs0R=uD1zXBOJkfSstGgMM=8bA1VVXGT+wQ@mail.gmail.com>
References: <CAEmTpZHkKB29FLWqs0R=uD1zXBOJkfSstGgMM=8bA1VVXGT+wQ@mail.gmail.com>
Date: Wed, 25 Jan 2012 16:20:26 +0600
Message-ID: <CAEmTpZH+OeQO=RNBFh_+j_QCmPa8sGhV_OOqqsiKUMmjhBwESw@mail.gmail.com>
Subject: Fwd: BUG in linux+v3.2.1/drivers/xen/xen-pciback/pci_stub.c
From: =?UTF-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= 
	<socketpair@gmail.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First, maintainer's addresses (Ryan Wilson <hap9@epoch.ncsc.mil>,
Chris Bookholt <hap10@epoch.ncsc.mil>) are wrong (users unknown to
remote mailsystem), so posting to you:

PCI bus format strings are wrong.

"%04x:%02x:%02x.%d"

should be used instead of

"%04x:%02x:%02x.%1x"

(in many places of linux+v3.2.1/drivers/xen/xen-pciback/pci_stub.c)

-- 
Segmentation fault
