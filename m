Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab1GQDwQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 23:52:16 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58862 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab1GQDwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 23:52:15 -0400
Date: Sun, 17 Jul 2011 11:51:50 +0800
From: "jiangtao.jit" <jiangtao.jit@gmail.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: problem with function vlan_get_protocol()
Message-ID: <201107171151478596113@gmail.com>
X-mailer: Foxmail 6, 15, 201, 26 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,all

in file   inclue/linux/if_vlan.h

there is a statement in function vlan_get_protocol()

	if (likely(protop))
		protocol = *protop;

do we need an else branch on pointer protop failed through the else is unlikely 

	if (likely(protop))
		protocol = *protop;
    else
		protocol = proto;

thanks

----------------------
2011-07-17 
jiangtao.jit 

