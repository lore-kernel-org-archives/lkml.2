Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803Ab1D2OFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 10:05:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63121 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757825Ab1D2OFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 10:05:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=RL68cpvv6ybrWOvZRg0s+Ec0SoUyM7ue7WQDIMqA+lTMb7T7Ne/JDmP3DXntVEBgBq
         D5SISY8Swk7ZpegCQvO6hlmRRSASEEzx/57sH/Hv7L7b1LKqwQsvxqQxSJDEOYNVXSEy
         z7nJrgyuyJNWwsJSmXnuOP6Gg+EKo128Ceujo=
Message-ID: <4DBAC59F.2020009@gmail.com>
Date: Fri, 29 Apr 2011 08:05:19 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: perf stat branch: perf stat fails on unsupported event
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tried the perf stat branch this morning. perf stat fails with:

# /tmp/build-perf/perf stat -- sleep 1
  Error: stalled-cycles-frontend event is not supported.
  Fatal: Not all events could be opened.

This is a Dell R410 with an E5620 processor.

David
