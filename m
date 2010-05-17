Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab0EQG1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 02:27:17 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41746 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab0EQG1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 02:27:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=EgChizIXqiDALCdecnSR9X+sMxTVi7THmnZSmiXDTnypf+d1+MNjAXksnzgt5oMFEl
         2YJhv6oMhYnnXwzm2YAkc4kZLMRAvSOg4zytbMf6C983oBcjWkmWmtbQlWHHOb1yP9vX
         /z+X3a4OGSetfERcf08C6JQvUJMMFRRNpvaMo=
MIME-Version: 1.0
Date: Mon, 17 May 2010 11:57:14 +0530
Message-ID: <AANLkTikD7M_PKH3YgOWIvrcD6aW6X-gYIo2iw52QRRq_@mail.gmail.com>
Subject: Which function returns LWP in Linux.
From: Srinivas Nayak <sinu.nayak2001@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

For a process, we have different PIDs. For threads under a single
processes, we have different LWP id, but same PID in Linux.
ex.

root@pc:/home/srinivas# ps -eLf
UID        PID  PPID     LWP  C STIME       TIME     CMD
root       100     1     100  0 May13       00:00:02 ./a.out
root       100     1     102  0 May13       00:00:00 ./a.out

getpid() function returns PID of a process.
Which function retuns LWP id for thread?

Sincerely,
Srinivas Nayak
