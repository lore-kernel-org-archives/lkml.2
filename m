Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab2FMMZF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 08:25:05 -0400
Received: from nm17-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.212]:23269 "HELO
	nm17-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754012Ab2FMMZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 08:25:03 -0400
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jun 2012 08:25:03 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 943113.46255.bm@omp1002.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type;
  b=tObHj70LlqDWY67FrKrygWrnOAtp2vs4dlc3xBf4T1Fd6/fze1gGSFDDjj8sU8CZiSsZwQkk3VRbqZqlR7LviLSJ8h8MD9ShgwhoCMGcheTe+UkM92if2y9OnM03JgRGi7mYWyQu06588dS18GQ29LLDB4zxta+ea8SmmMgc/NA=;
X-YMail-OSG: s__ioHcVM1lDroakFm3SBilmBt2s._S8Oy7o4yTyfuM9HXN
 tfC4xsbuHs8KxRGImMutpe3UUmlDzEaX68V8l1iJEXs220gXMNO1pLRAC2rh
 7YwU.57HqNgyT_bfzct8uMVE033veKrAZjSK2R5g0msPvTlnfHujtReswZ4H
 rGTbBDG1FbPKOsNCxrdFsCqE.zlxFOwUNtJZkypgvsbHCrpCREjNsjymog6i
 nGM5y78Dql7vUwOMLP.IDOgrQgQO3hf_pQZey6zbwEu.7WHBeSj5V9RkWp8u
 CXfRrVddRUgNIteplA_UPs1uNLkmijWeTgBeqfX4rYcK_frYAfyTzJCmhoRA
 FyYTJE1.MQ4QUw7xmWS3_CUtxGm2kXAUeJ3mYycb7M7qtsY9dVCkVigYVvpb
 t__r30kwqpO8_vm9Sl.7kK6hXE4P.b6Ct5cYp2SvumKVyvYT5BR7640VKOJu
 uFL3fYQ--
X-Mailer: YahooMailWebService/0.8.118.349524
References: 
Message-ID: <1339589919.53487.YahooMailNeo@web111718.mail.gq1.yahoo.com>
Date: Wed, 13 Jun 2012 05:18:39 -0700 (PDT)
From: Mahmood Naderan <nt_mahmood@yahoo.com>
Reply-To: Mahmood Naderan <nt_mahmood@yahoo.com>
Subject: logging on kernel panic
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody
If a system receives kernel panic during boot, will it be logged somewhere?
In our diskless cluster, clients boot from an image located at /nfsroot
Normally /nfsroot/var/log/syslog should contain messages. However
on a kernel panic, there is no log in /nfsroot/var/log/syslog/


~MN
