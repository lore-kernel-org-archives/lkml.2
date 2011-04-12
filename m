Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab1DLUx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 16:53:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40420 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932361Ab1DLUx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 16:53:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:date:from:to:cc:message-id:in-reply-to:references;
        b=QN09QYfAddm1gQ1mziRiOGSC3lXKHHo8jlRGpbc3Js0dM6cd2+mXB03gILGPxiEU8T
         1FIJavExUoB2CowgOL5aoqp4NicaPJ32cnq2DPvbTmdzHhZ7D9dpfoJVyknEAPjn6KLo
         b0c8bUdOfF4yKSM2s3/Ly2CLVkC5oqC6BOnK0=
Subject: [PULL] Improve Python 3 handling
Date: Tue, 12 Apr 2011 20:52:24 +0000
From: Michael Witten <mfwitten@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Raghavendra D Prabhu <rprabhu@wnohang.net>, linux-kernel@vger.kernel.org
Message-ID: <68012314-7275-4397-8141-573335f969af-mfwitten@gmail.com>
In-Reply-To: <7f7c5d35-e644-4950-a3d3-dfcf46d5237e-mfwitten@gmail.com>
References: <20110326224408.GA1336@Xye>
            <20110328144721.GB17872@ghostprotocols.net>
            <e987828e-87ec-4973-95e7-47f10f5d9bab-mfwitten@gmail.com>
            <20110329181524.GA5140@Xye>
            <AANLkTi=3Wq3Xt-QFR-FLRQ1kBjpWjaBZNFpOiE_T15WH@mail.gmail.com>
            <20110329204024.GA20824@ghostprotocols.net>
            <3a97df19-e376-412a-95be-37ffde765cc3-mfwitten@gmail.com>
            <20110408211709.GA5155@Xye>
            <5f5948dd-2c38-4ed3-8544-99c137204d07-mfwitten@gmail.com>
            <20110409184245.GA5115@Xye>
            <7f7c5d35-e644-4950-a3d3-dfcf46d5237e-mfwitten@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's get this finished up.

Arnaldo, pull from here:

  git://github.com/mfwitten/linux-2.6.git perf/makefile/config

to get the Python stuff plus a little clean up (for the sake of
consistency and in preparation for improving the process of
configuring the build).

  [0] perf tools: Makefile: Clean up `python/perf.so' rule
  [1] perf tools: Makefile: PYTHON{,_CONFIG} to bandage Python 3 incompatibility
  [2] perf tools: Move `try-cc'
  [3] perf tools: git mv tools/perf/{features-tests.mak,config/}

Stats:

  tools/perf/Makefile                       |  107 ++++++++++++----
  tools/perf/{ => config}/feature-tests.mak |   16 +--
  tools/perf/config/utilities.mak           |  188 +++++++++++++++++++++++++++++
  3 files changed, 276 insertions(+), 35 deletions(-)
  rename tools/perf/{ => config}/feature-tests.mak (86%)
  create mode 100644 tools/perf/config/utilities.mak

Sincerely,
Michael Witten
