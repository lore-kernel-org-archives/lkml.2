Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab0JQCpS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 22:45:18 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:26177 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757251Ab0JQCpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 22:45:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AigDAEcAukxMCo4F/2dsb2JhbAAHgxidFLJukQ6BIoMzdASSGQ
X-IronPort-AV: E=Sophos;i="4.57,341,1283745600"; 
   d="scan'208";a="79843431"
Message-ID: <4CBA6338.20700@teksavvy.com>
Date: Sat, 16 Oct 2010 22:45:12 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tracey Dent <tdent48227@gmail.com>
CC: jgarzik@pobox.com, linux-kernel@vger.kernel.org, avorontsov@ru.mvista.com,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH] Drivers: ata: Makefile: replace the use of <module>-objs
 with <module>-y
References: <1287200493-2024-1-git-send-email-tdent48227@gmail.com>
In-Reply-To: <1287200493-2024-1-git-send-email-tdent48227@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-10-15 11:41 PM, Tracey Dent wrote:
> Changed<module>-objs to<module>-y in Makefile.
..
> -libata-objs	:= libata-core.o libata-scsi.o libata-eh.o libata-transport.o
> +libata-y	:= libata-core.o libata-scsi.o libata-eh.o libata-transport.o


Why?
