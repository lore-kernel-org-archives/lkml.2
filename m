Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab0DFQt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 12:49:28 -0400
Received: from thoth.sbs.de ([192.35.17.2]:17829 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224Ab0DFQtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 12:49:22 -0400
Message-ID: <4BBB65EF.1030804@siemens.com>
Date: Tue, 06 Apr 2010 18:48:47 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Helight.Xu" <helight.xu@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] proc: Report file name on detected read_proc overflow
References: <4BB49B0E.8070306@siemens.com> <o2mb6fcc0a1004012328g2b61260bibadbfd8f3d6f87ce@mail.gmail.com>
In-Reply-To: <o2mb6fcc0a1004012328g2b61260bibadbfd8f3d6f87ce@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On Thu, Apr 1, 2010 at 4:09 PM, Jan Kiszka <jan.kiszka@siemens.com> wrote:
>> This can help identifying the buggy read_proc handler.
> 
> ->read_proc is going to be removed, so there is no point.

OK. What is the planned kernel release or date?

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
