Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760399Ab2C3MQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 08:16:57 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57797 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349Ab2C3MQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 08:16:50 -0400
Message-ID: <4F75A42E.3030704@kernel.org>
Date: Fri, 30 Mar 2012 08:16:46 -0400
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110906 Fedora/3.1.14-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.14
MIME-Version: 1.0
To: Corentin Chary <corentin.chary@gmail.com>
CC: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 57/76] ACPI / Video: blacklist some samsung laptops
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>	<1333102459-23750-1-git-send-email-lenb@kernel.org>	<0e569b120d19c35dcc4f5549956cd884c3241270.1333101989.git.len.brown@intel.com> <CAHR064iEVsoMiP1PYzXeZeZzOFCPTk1YDBty6nHAfzej2qh_qA@mail.gmail.com>
In-Reply-To: <CAHR064iEVsoMiP1PYzXeZeZzOFCPTk1YDBty6nHAfzej2qh_qA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Sorry for that but this patch was re-sent recently, and Matthew told
> me to do that this should be done in samsung-laptop.c instead.

Okay, I'll revert the (soon to be un-necessary) blacklist entries.

thanks,
-Len
