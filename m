Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932877Ab1EZUgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 16:36:47 -0400
Received: from higgs.elka.pw.edu.pl ([194.29.160.5]:44427 "EHLO
	higgs.elka.pw.edu.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212Ab1EZUgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 16:36:47 -0400
X-Comment: RFC 2476 MSA function at elektron.elka.pw.edu.pl logged sender identity as: wzabolot
Message-ID: <4DDEB9D5.60606@elektron.elka.pw.edu.pl>
Date: Thu, 26 May 2011 22:36:37 +0200
From: "wzabolot@elektron.elka.pw.edu.pl" <W.Zabolotny@elka.pw.edu.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110402 Icedove/3.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Wrong (0777) permissions on root filesystem after booting the
 kernel
References: <4DDE99A9.60401@elektron.elka.pw.edu.pl> <4DDE9DEC.7090208@elektron.elka.pw.edu.pl>
In-Reply-To: <4DDE9DEC.7090208@elektron.elka.pw.edu.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK. The problem is resolved. I've forgotten that permissions of the root 
node are stored in the filesystem image.
So now the only problem is to find: how the permissions got changed.
Was it a mistake during system maintenance/upgrade or the system got 
somehow compromised :-(.
-- 
Sorry for confusion,
Wojtek
