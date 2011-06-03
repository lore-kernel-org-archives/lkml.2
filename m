Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab1FCP1g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 11:27:36 -0400
Received: from nm8-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.194]:42008 "HELO
	nm8-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753871Ab1FCP1e convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 11:27:34 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 653252.8978.bm@omp1018.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ymail.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=PTcm8at7553kKAFeKgYF3/da94p2soP8t2NO5yzjXgyOSAVby1/QdsVDI88C/G+/TnJ0tbBJ7dnsZpBQIswNDNiFhZGoK8xEW1jzerXUazoATbD9J+6A9WYYwlfBQBRkU4bPwODqYNDY0yBNFncGCiyUY8gwt1+q1o0tGur1W6I=;
Message-ID: <9945.23050.qm@web111015.mail.gq1.yahoo.com>
X-YMail-OSG: C_HOLtMVM1n0WqvJKosOOov0lp9nJEZuztEAQWga4oFE1Co
 s3KF9bj5KHOK..UQQ5_JDpA7e1ULnbsB5ubF8cLiQQQqzKZbb0GI9CqwrH24
 mC1DXlhfvBDujsTnDwVsBVDlZXGy0BTlN0vkNvE3SyyQqPex8PVvpdx1GeRB
 X96cHHT9jzSS9J0WGzMcevDWKEYfrX4_09jj3KuF6phZ53XAICg2w1AAHzUs
 Cr0rgxbllkasOz_.KxRF2J08W76hHNlqO3ECBzbCOB2jIPrrpND056gZsD8n
 I4cBsRD23VyNCFLd9YLFH.eUE9F6aEa3711LQ8nLuq9Y7EAz16S070RjT0oQ
 IuM547crY4dcNTG3iOPfTkcN0hmDkGJm4RyrqhmNn_d4242lsPCsWax05CQl
 .sAf8Gi3R7awycOp9Qet6dnBnWA--
X-Mailer: YahooMailClassic/14.0.1 YahooMailWebService/0.8.111.304355
Date: Fri, 3 Jun 2011 08:27:32 -0700 (PDT)
From: Andrew Watts <akwatts@ymail.com>
Subject: Re: git torvalds/linux-2.6.git gives obscure results
To: richard -rw- weinberger <richard.weinberger@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>
Cc: =?iso-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <87lixjxfbh.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- 6/3/11, Bjørn Mork <bjorn@mork.no> wrote:
> There's a problem with the git installation on one of the
> geo located
> git.kernel.org servers, namely git4.kernel.org located at
> the University
> of Umeå:
> 
> bjorn@canardo:~$ telnet git4.kernel.org git
> Trying 130.239.17.8...
> Connected to git4.kernel.org.
> Escape character is '^]'.
> git: 'daemon' is not a git command. See 'git --help'.
> Connection closed by foreign host.

Unfortunately, the problem seems to be more pervasive. git1.kernel.org also errors out on clones/pulls with the error: "fatal: protocol error: bad line length character: git:". I confirm that the return packet payload on the errors is: "git: 'daemon' is not a git command. See 'git --help'".

~ Andy

