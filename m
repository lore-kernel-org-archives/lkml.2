Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab1CYNW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:22:27 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:34540 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab1CYNWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:22:25 -0400
From: Oliver Neukum <oliver@neukum.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: question on DMA of const string
Date: Fri, 25 Mar 2011 14:23:07 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8-12-desktop+; KDE/4.4.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201103251423.07611.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

is there a way to declare a const string so that it can be sent directly
by DMA?

	Regards
		Oliver
