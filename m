Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932847Ab1BYV56 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 16:57:58 -0500
Received: from tomasu.net ([64.85.170.234]:44418 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932105Ab1BYV55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 16:57:57 -0500
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
To: linux-kernel@vger.kernel.org
Subject: File/memory corruption in 2.6.37?
Date: Fri, 25 Feb 2011 14:57:51 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.37-1-amd64; KDE/4.5.2; x86_64; svn-1188918; 2010-10-21)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201102251457.51476.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ever since I upgraded to 2.6.37 from 2.6.36, that kmail's folder indexes are 
being corrupted fairly regularly. Far more often than is usual (almost never). 
Several a day in fact are being corrupted. I can only imagine that this isn't 
the only corruption happening and it is worrying.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
