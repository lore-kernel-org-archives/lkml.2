Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933779Ab1CXImE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 04:42:04 -0400
Received: from srv04.jarevo.de ([88.198.54.146]:55763 "EHLO srv04.jarevo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933713Ab1CXImA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 04:42:00 -0400
Message-ID: <4D8B03D6.2090204@nachtgeist.net>
Date: Thu, 24 Mar 2011 09:41:58 +0100
From: Daniel Reichelt <debian@nachtgeist.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: procfs: boot- and runtime configurable access mode for /proc/<pid>
 dirs
References: <4D8AC408.9000503@nachtgeist.net> <20110324073225.GA3806@p183.telecom.by>
In-Reply-To: <20110324073225.GA3806@p183.telecom.by>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Keeping u/g/o inside kernel is horrible.

Why exactly? Since it's only a char and not char[] I don't see the
disadvantage over int or a define or whatever. Of course I could always
change that if that's a de-facto standard I just didn't know about.


> What is the usecase? Content of /proc/* is identical.

Use-case is to isolate process information from other users' or groups'
eyes, e.g. with 550 the output of ps aux only lists processes of the
groups your user is a member of.
