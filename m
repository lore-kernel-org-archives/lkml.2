Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab0EGOJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 10:09:47 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19073 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab0EGOJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 10:09:40 -0400
Date: Fri, 7 May 2010 17:07:59 +0300
From: Ozgur Yuksel <ozgur.yuksel@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bugme-new] [Bug 15610] New: fsck leads to swapper - BUG:
 unable to handle kernel NULL pointer dereference & panic
Message-ID: <20100507140759.GA22664@oracle.com>
References: <bug-15610-10286@https.bugzilla.kernel.org/>
 <20100322100954.5ecaec4b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100322100954.5ecaec4b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090203.4BE41ED5.0136:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During bisecting, I needed to switch to another environment (Xen HVM - Fedora 
12) where I could never reproduce the problem there. I cannot proceed on
analysis on the original environment as it is my main workstation. 

FWIW I can confirm the problem did not reproduce on 2.6.34-rc3 on the original
environment too. 

Ozgur Yuksel
