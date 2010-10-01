Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab0JAHcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 03:32:09 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:4913 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751278Ab0JAHcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 03:32:07 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host o917WMxB008621
Subject: Re: linux-kernel 0.11 compile
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: runcoderen <runcoderzhcn@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1285894187.1613.17.camel@bencharluo-laptop>
References: <1285894187.1613.17.camel@bencharluo-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Oct 2010 09:32:02 +0200
Message-ID: <1285918322.2384.7.camel@thorin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-DCC-wuwien-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fre, 2010-10-01 at 08:49 +0800, runcoderen wrote: 
> hi all:
> I am compiling kernel 0.11.
> but It notes me that make : gas : command cannot find.

Apart from the potential "Ubuntu is far too new" problem:
"gas" was the name of the binary of the "GNU assembler".

On Fedora 13, it is now called "as".

[...] 
> my platform is ubuntu10.10(DVD installed style)


Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

