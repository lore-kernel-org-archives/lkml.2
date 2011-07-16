Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab1GPTDJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 15:03:09 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:38273 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751794Ab1GPTDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 15:03:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=qiLTlmZLn7pR67JCiBm2l41SlroaZ3/RHD69R/N4gBZdl9royR+zyN+kYWkcjuKt1kMhqBsO+LH8yptCuhUOz2xuxYrIIriSyUmaW0YuwHkTQosxYZkAxRk6uPl9fiSv;
Date: Sat, 16 Jul 2011 12:03:04 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-acpi@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 16 (acpi/apei)
Message-Id: <20110716120304.83d79985.rdunlap@xenotime.net>
In-Reply-To: <20110717000815.c83755be9598d34ac8431908@canb.auug.org.au>
References: <20110717000815.c83755be9598d34ac8431908@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jul 2011 00:08:15 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20110707:


When # CONFIG_ACPI_APEI_GHES is not set:

(.init.text+0x4c22): undefined reference to `ghes_disable'

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
