Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab1DZORx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 10:17:53 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:33763 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755273Ab1DZORw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 10:17:52 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DB6D3DE.5040302@verizon.net>
Date: Tue, 26 Apr 2011 10:17:02 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-kbuild@vger.kernel.org>,
        <mmarek@suse.cz>
Subject: Re: [PATCH] kbuild: fix sed error in export_report.pl
References: <4DB608EE.1060502@verizon.net> <BANLkTi=sjE-YF1+q1++Bk78n4bvs6W5Wgg@mail.gmail.com>
In-Reply-To: <BANLkTi=sjE-YF1+q1++Bk78n4bvs6W5Wgg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/26/2011 2:40 AM, Arnaud Lacombe wrote:
> Hi,
> 
> On Mon, Apr 25, 2011 at 7:51 PM, Peter Foley <pefoley2@verizon.net> wrote:
>> This patch fixes a sed error in export_report.pl by escaping a $.
>>
> Which error ?
> 
> Thanks,
>  - Arnaud
> 

This is the error I get:

make -C /usr/src/git O=/root/linux/t/. export_report
perl /usr/src/git/scripts/export_report.pl
sed: -e expression #1, char 5: unterminated `s' command
sh: line 1: .mod.c/: No such file or directory
