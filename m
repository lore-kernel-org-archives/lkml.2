Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab2FSXJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 19:09:10 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40408 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab2FSXJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 19:09:08 -0400
MIME-Version: 1.0
Date: Tue, 19 Jun 2012 18:09:07 -0500
Message-ID: <CAB7xdik9-U_4ODdcGTfhPg+Ma2rZ11Q9ixnW-uH6AoORj=Zvwg@mail.gmail.com>
Subject: how to map a host virtual address (hva) to guest address space (gva/gpa/gfn)
From: sheng qiu <herbert1984106@gmail.com>
To: kvm <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

is there any existing function in KVM that can map a host virtual
address (hva) to the guest address space. So that the guest VM can
access it.
i.e. translate hva to a gpa or gva or gfn, so the guest VM can use
that converted address to access?

Thanks,
Sheng
