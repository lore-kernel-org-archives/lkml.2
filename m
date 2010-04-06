Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab0DFNAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 09:00:39 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:62226 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755124Ab0DFNAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 09:00:34 -0400
From: Frans Pop <elendil@planet.nl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.34-rc3: Can't insmod after make, because versions now differ?!
Date: Tue, 6 Apr 2010 15:00:31 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <20100405053628.GA12217@elf.ucw.cz> <201004051724.26225.elendil@planet.nl> <20100406070641.GA19231@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20100406070641.GA19231@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004061500.32569.elendil@planet.nl>
X-OriginalArrivalTime: 06 Apr 2010 13:00:32.0903 (UTC) FILETIME=[24422170:01CAD589]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 April 2010, Pavel Machek wrote:
> Yes, but... should module version checking be fixed so that it does
> not interfere like that?

I don't think so. Essentially you are getting what you configured: an 
extremely fine-grained kernel version. It's up to you to decide whether 
the benefits of that outweigh the limitations it brings.

Stripping parts of the kernel version for module compatibility checks could 
interfere with suffixes explicitly added by distros to specify ABI 
compatibility.

Cheers,
FJP
