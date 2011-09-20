Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab1ITHvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 03:51:55 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59752 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab1ITHvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 03:51:54 -0400
MIME-Version: 1.0
Date: Tue, 20 Sep 2011 15:44:49 +0800
Message-ID: <CA+UXGK2rDrOvmpeugn2=HjSY6y8=D+L-rvkY8eLX7LvTQnzTVw@mail.gmail.com>
Subject: bridge and ipv6 question.
From: Eric Xiong <bottomofstack@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all:
Sorry for disturb! when adding a interface to bridge, maybe the bridge
mac address will be changed. the bridge code don't invoke
call_netdevice_notifiers to notify ipv6 code to refresh local link
address. I don't know why. Thanks for your help!
