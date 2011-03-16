Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750870Ab1CPOKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 10:10:53 -0400
Received: from mail1.slb.deg.dub.stisp.net ([84.203.253.98]:10887 "HELO
	mail1.slb.deg.dub.stisp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752242Ab1CPOKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 10:10:45 -0400
Message-ID: <4D80C47C.80300@draigBrady.com>
Date: Wed, 16 Mar 2011 14:09:00 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Aneesh Bhasin <contact.aneesh@gmail.com>
CC: Randy Dunlap <rdunlap@xenotime.net>,
        linux-newbie <linux-newbie@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: smap output - unnamed entries and heap
References: <AANLkTik3N5j74eWastminNZLevPqoSCEiVCrX1vP66_k@mail.gmail.com> <20110315091412.de6eb63c.rdunlap@xenotime.net> <AANLkTikU_kPOoNv6gJiPOsmrkFDddTLQ-0--wViYyFxj@mail.gmail.com>
In-Reply-To: <AANLkTikU_kPOoNv6gJiPOsmrkFDddTLQ-0--wViYyFxj@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/03/11 05:19, Aneesh Bhasin wrote:
> Also, is there a way in linux (without using
> dedicated tools like valgrind), to see how much heap or anonymous
> memory is attributed to code arising from a particular library/binary

You might find ps_mem.py useful.
If parses smaps and reports RAM usage of a program

http://www.pixelbeat.org/scripts/ps_mem.py

cheers,
Pádraig.
