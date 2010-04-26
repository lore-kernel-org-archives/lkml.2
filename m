Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab0DZMvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 08:51:46 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:39134 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab0DZMvp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 08:51:45 -0400
MIME-Version: 1.0
Message-ID: <2634f2cb-3e7e-4c86-b7ef-cf4a3f1e0d8a@default>
Date: Mon, 26 Apr 2010 05:50:26 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Avi Kivity <avi@redhat.com>, ngupta@vflare.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
       hugh.dickins@tiscali.co.uk, JBeulich@novell.com, chris.mason@oracle.com,
       kurt.hackel@oracle.com, dave.mccracken@oracle.com, npiggin@suse.de,
       akpm@linux-foundation.org, riel@redhat.com
Subject: RE: Frontswap [PATCH 0/4] (was Transcendent Memory): overview
References: <20100422134249.GA2963@ca-server1.us.oracle.com>
 <4BD06B31.9050306@redhat.com> <53c81c97-b30f-4081-91a1-7cef1879c6fa@default>
 <4BD07594.9080905@redhat.com> <b1036777-129b-4531-a730-1e9e5a87cea9@default>
 <4BD16D09.2030803@redhat.com> <b01d7882-1a72-4ba9-8f46-ba539b668f56@default>
 <4BD1A74A.2050003@redhat.com> <4830bd20-77b7-46c8-994b-8b4fa9a79d27@default>
 <4BD1B427.9010905@redhat.com> <4BD24E37.30204@vflare.org>
 <4BD33822.2000604@redhat.com> <4BD3B2D1.8080203@vflare.org>
 <4BD4329A.9010509@redhat.com> <4BD4684E.9040802@vflare.org
 4BD52D55.3070803@redhat.com>
In-Reply-To: <4BD52D55.3070803@redhat.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4BD58C44.00EC:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Maybe incremental development is better? Stabilize and refine
> existing
> > code and gradually move to async API, if required in future?
> 
> Incremental development is fine, especially for ramzswap where the APIs
> are all internal.  I'm more worried about external interfaces, these
> stick around a lot longer and if not done right they're a pain forever.

Well if you are saying that your primary objection to the
frontswap synchronous API is that it is exposed to modules via
some EXPORT_SYMBOLs, we can certainly fix that, at least
unless/until there are other pseudo-RAM devices that can use it.

Would that resolve your concerns?
