Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821Ab1LFA37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 19:29:59 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48366 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932706Ab1LFA35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 19:29:57 -0500
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Mon, 5 Dec 2011 16:29:36 -0800
X-Google-Sender-Auth: wo2mU_JBnBZ0rRTEJ-ur7ofALcI
Message-ID: <CAB=NE6Uz_gXkY3HGXeW1OnPx84fPVUP=gOJ=2NjBtPZhW=_Bbw@mail.gmail.com>
Subject: Is linux-next.git bisectable?
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

is the linux-next.git tree bisectable? I've noticed some trees are
not. For example wireless-testing.git is bisectable but only between
master-$(date) tags.

  Luis
