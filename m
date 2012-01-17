Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab2AQUqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 15:46:15 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52062 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab2AQUqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 15:46:12 -0500
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Tue, 17 Jan 2012 12:40:35 -0800
X-Google-Sender-Auth: 4cOgcKLFE5Zo2YY5TgQM9HjI_dE
Message-ID: <CAB=NE6WnEwD58OXS0uqd_emdS+YhPaP+KKKbfGwCdNCCHZdLyA@mail.gmail.com>
Subject: atl1c, etc bugs
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: nic-devel@qualcomm.com, "Huang, Xiong" <xiong@qca.qualcomm.com>,
        "Ren, Cloud" <cjren@qca.qualcomm.com>,
        Kathy Giori <kgiori@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please Cc nic-devel@qualcomm.com in future atl1c and atl1x driver bug
reports on bugzilla.kernel.org, whether or not they will be looked at
will depend but moving forward we are trying to get more attention to
these from QCA (Qualcomm Atheros). Baby steps. I considered adding
that address to the MAINTAINERS file but it seemed rather
inappropriate. In the meantime we are reviewing a new driver that also
supports some older chipsets but that the team may be willing to
commit to supporting and reviewing all bugs for. We'll see..

  Luis
