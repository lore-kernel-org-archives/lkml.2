Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab1BYWIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 17:08:48 -0500
Received: from tomasu.net ([64.85.170.234]:50167 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756087Ab1BYWIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 17:08:47 -0500
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
To: linux-kernel@vger.kernel.org
Subject: Re: File/memory corruption in 2.6.37?
Date: Fri, 25 Feb 2011 15:08:45 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.37-1-amd64; KDE/4.5.2; x86_64; svn-1188918; 2010-10-21)
References: <201102251457.51476.thomas@fjellstrom.ca>
In-Reply-To: <201102251457.51476.thomas@fjellstrom.ca>
MIME-Version: 1.0
Message-Id: <201102251508.45122.thomas@fjellstrom.ca>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On February 25, 2011, you wrote:
> Ever since I upgraded to 2.6.37 from 2.6.36, that kmail's folder indexes
> are being corrupted fairly regularly. Far more often than is usual (almost
> never). Several a day in fact are being corrupted. I can only imagine that
> this isn't the only corruption happening and it is worrying.

Forgot to give any kind of useful info:

System: Lenovo SL500 laptop, intel core2duo T9400 cpu, 4G ram, gm45 intel gfx

running debian sid, with the current debian 2.6.37 kernel, was running a hand 
rolled 2.6.36 kernel with autogroup applied and didn't have these issues.

The only real change has been an updated kernel, and some other misc packages. 
(not any KDE packages, have to compile it myself since debian has fallen WAY 
behind on KDE again).

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
