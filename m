Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210Ab1EMPPN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 11:15:13 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58082 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293Ab1EMPPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 11:15:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:content-type;
        b=ONeGQ7ps45PdBNoJgjwT84rgpI0kDO0QzyPBN3w5vhhvJ92sd0r7Cx6GaahuBtjP/k
         UDdQMnvO0GQk4Ta34g/6nwXnBkgGNQy50kqI0rd7rXakHPvdn8vHpTVeVt0pLA5n6F/x
         4aux/h1hWHPpqHlNA9/286rtdVne1CcQ20DJE=
MIME-Version: 1.0
From: Wim Heirman <wim@heirman.net>
Date: Fri, 13 May 2011 17:14:51 +0200
X-Google-Sender-Auth: 0TUIM_dS0IaWpWcLd2ip2vZ36L8
Message-ID: <BANLkTimTOTz4qNwYPa6Ey7=QRjOhQHWt-Q@mail.gmail.com>
Subject: perf-stat per thread results
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm using perf-stat to look at hardware performance counters for a
parallel program. Is there a way to get counter values for each thread
individually, rather than aggregated for the whole process? I know I
can attach to a specific thread using --tid=, but due to the time
required to find the tid and attach/detach this isn't accurate for
short-running programs.
Or, alternatively, can I use perf record --stat and get an exact count
for each performance counter?

Thanks,
Wim Heirman
Ghent University, Belgium
