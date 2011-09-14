Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932767Ab1INNn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 09:43:56 -0400
Received: from mail-gw0-f61.google.com ([74.125.83.61]:62238 "EHLO
	mail-gw0-f61.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548Ab1INNnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 09:43:55 -0400
Path: glegroupsg2000goo.googlegroups.com!not-for-mail
Newsgroups: fa.linux.kernel
Date: Wed, 14 Sep 2011 06:32:15 -0700 (PDT)
In-Reply-To: <ee48c89a-1e72-4b35-b9fc-99f4b8ade483@glegroupsg2000goo.googlegroups.com>
Reply-To: fa.linux.kernel@googlegroups.com
Complaints-To: groups-abuse@google.com
Injection-Info: glegroupsg2000goo.googlegroups.com; posting-host=81.164.208.103;
 posting-account=TmuePgoAAADCroGlXr-Y1Eqc_ttgkFy1
NNTP-Posting-Host: 81.164.208.103
References: <fa.FZDTDqnxL4JfQvyaCQTn405rzwM@ifi.uio.no> <ee48c89a-1e72-4b35-b9fc-99f4b8ade483@glegroupsg2000goo.googlegroups.com>
User-Agent: G2/1.0
X-Google-Web-Client: true
MIME-Version: 1.0
Message-ID: <ab6fdfe9-bc29-4ba1-92cc-e7b4ec9cddea@glegroupsg2000goo.googlegroups.com>
Subject: Re: iotop: khugepaged at 99.99% (2.6.38.3)
From: Slawomir Czarko-Wasiutycz <slawomir.czarko@gmail.com>
To: fa.linux.kernel@googlegroups.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correction - CONFIG_PREEMPT=y doesn't fix the problem. It just delays its occurrence and when it happens the problem seems to be less severe.
