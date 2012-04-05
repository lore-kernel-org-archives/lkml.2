Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409Ab2DEGAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 02:00:22 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43571 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab2DEGAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 02:00:21 -0400
MIME-Version: 1.0
Date: Thu, 5 Apr 2012 14:00:20 +0800
Message-ID: <CAOVJa8EVHhfFfHHNAyAeT0ZYj3vZFW3Uu4K2PzBEGGOz92fhiw@mail.gmail.com>
Subject: some questions about __get_vm_area_node
From: vichy <vichy.kuo@gmail.com>
To: Kernel Newbies <kernelnewbies@nl.linux.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all:
I have a question about __get_vm_area_node.
Q. Why we announce "static struct vmap_area *va;" instead of "struct
vmap_area *va;"
I cannot see is there any benefit to take this variable as static.

Thanks for your help in advance.
