Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654Ab1JNR1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 13:27:08 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43674 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab1JNR1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 13:27:07 -0400
Date: Fri, 14 Oct 2011 14:26:59 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [perf PATCH] Fix possible unterminated readlink() result buffer
Message-ID: <20111014172659.GB19655@ghostprotocols.net>
References: <4E986ABF.9040706@intra2net.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E986ABF.9040706@intra2net.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Oct 14, 2011 at 07:00:47PM +0200, Thomas Jarosch escreveu:
> No need to do "buf[len] = '\0';" since the buffer
> is allocated with zalloc().
> 
> Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>

Thanks, applied.

- Arnaldo
