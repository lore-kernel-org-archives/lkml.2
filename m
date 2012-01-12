Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab2ALUqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 15:46:46 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41012 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378Ab2ALUqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 15:46:45 -0500
Date: Thu, 12 Jan 2012 12:46:42 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: how to get of the the "plus" in 3.2.0+
In-Reply-To: <CAAJw_ZvxGc8kKjLO49ONLG=AuU6-DXExwNk2PuRszF1Y0jVeog@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1201121242560.17287@chino.kir.corp.google.com>
References: <CAAJw_ZvxGc8kKjLO49ONLG=AuU6-DXExwNk2PuRszF1Y0jVeog@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="397155492-191808671-1326401204=:17287"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--397155492-191808671-1326401204=:17287
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 13 Jan 2012, Jeff Chua wrote:

> Every time I do a fresh compile of the kernel, it append the version
> with a "+". How can I get rid of the annoying "+" without doing
> another major recompile or before I even start the compiling?
> 

The `+´ is emitted to indicate that you have modifications to your tree 
beyond an official release, so your tree is actually not 3.2.0 but rather 
it has additional changes on top of 3.2.0.

To suppress it, use "make LOCALVERSION="

The version string is written to include/generated/utsrelease.h at the 
beginning of the build.
--397155492-191808671-1326401204=:17287--
