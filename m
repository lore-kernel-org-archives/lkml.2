Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab2IWUTN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 16:19:13 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:33134 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452Ab2IWUS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 16:18:57 -0400
Date: Sun, 23 Sep 2012 23:18:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Roberto Corrado <i@secure.corradoroberto.it>
Cc: linux-kernel@vger.kernel.org
Subject: Re: WARNING: at block/genhd.c:1570 disk_clear_events+0xbf/0xd0()
Message-ID: <20120923201803.GA25161@mwanda>
References: <98D4C13641D5474D9995328F2593DF7E@unknown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98D4C13641D5474D9995328F2593DF7E@unknown>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have created a bug for this:
https://bugzilla.kernel.org/show_bug.cgi?id=47871

Please add the following information:
*) Last known good kernel version
*) Current broken kernel version
*) Complete dmesg

regards,
dan carpenter
