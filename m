Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab1GLKbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 06:31:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052Ab1GLKbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 06:31:06 -0400
Message-ID: <4E1C223A.9000705@redhat.com>
Date: Tue, 12 Jul 2011 18:30:18 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Takao Indoh <indou.takao@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, ebiederm@xmission.com, vgoyal@redhat.com,
        rdunlap@xenotime.net, lenb@kernel.org, linux-doc@vger.kernel.org,
        linux-acpi@vger.kernel.org, mjg@redhat.com
Subject: Re: [PATCH v2] acpi: introduce "acpi_rsdp=" parameter for kdump
References: <E8CC3FDD41FF9Findou.takao@jp.fujitsu.com>
In-Reply-To: <E8CC3FDD41FF9Findou.takao@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年07月11日 23:14, Takao Indoh 写道:
> Revised version of the patch which was posted by Cong WANG
>
> Changes in v2:
> * Change parameter name from "acpi_addr" to "acpi_rsdp"
> * Add CONFIG_KEXEC

Thanks for updating it! Definitely looks good to me,

Reviewed-by: WANG Cong <amwang@redhat.com>
