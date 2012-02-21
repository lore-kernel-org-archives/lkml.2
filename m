Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab2BUDpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 22:45:12 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65423 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab2BUDpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 22:45:10 -0500
MIME-Version: 1.0
From: Yang Bai <hamo.by@gmail.com>
Date: Tue, 21 Feb 2012 11:44:49 +0800
Message-ID: <CAO_0yfNLNuYrZoXLsdQCaVchaBvWD3UiTw74RiS5Ppfd_sXoZw@mail.gmail.com>
Subject: question about {target,expander,port}_id allocation for scsi_transport_sas
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I want to move there 3 id allocation from the simple way to ida. I
have some questions about this:

1. We have a struct sas_host_attrs to hold the 3 int for the next id
and a mutex for protect them. What's the purpose of the other 2
members (rphy_list and q). Are they related about these 3 id's
allocation?

2. Since for ida, we need a static struct, and for there 3 ids, we
need 3. Where can I store them? In the host's struct? Or somewhere
else?


Thanks and waiting for your help,
Yang
