Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab0DGMZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 08:25:18 -0400
Received: from perec.tyrell.hu ([66.197.149.104]:55665 "EHLO perec.tyrell.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216Ab0DGMZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 08:25:16 -0400
Message-ID: <4BBC7998.5080106@maroy.hu>
Date: Wed, 07 Apr 2010 14:24:56 +0200
From: =?UTF-8?B?w4Frb3MgTWFyw7N5?= <akos@maroy.hu>
Organization: Tyrell Corporation
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: "Justin P. mattock" <justinmattock@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: system does not power off - how to debug?
References: <4BBC2E3E.40308@maroy.hu> <4BBC30B3.1000209@gmail.com>
In-Reply-To: <4BBC30B3.1000209@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin,

> Since this issue seems easily reproducible
> the best way to find the issue is through
> a bisect(hardest part is finding the last
> good kernel),
> http://www.kernel.org/pub/software/scm/git/docs/user-manual.html
> 
> hope this helps,

hm, but wouldn't this assume that there is a kernel version, which
actually works?


Akos

