Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412Ab0HDXAX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 19:00:23 -0400
Received: from web27001.mail.ukl.yahoo.com ([217.146.177.1]:22807 "HELO
	web27001.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757366Ab0HDW76 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 18:59:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=cfXYU6ZtagGTmHjkJt8N60n00gTvyBB5UQ1zK9sEJ3MCEejJrEUyQeUqQZ7/mCpDgvVc4QvxGwY2amQtGSTyN5YK0ZfhHkNxN/3BFdCGkf8S4a+Ycv/gesuy5b8+CwgJOAxfN557gFBlngOF1lFSBxO/jElaogl08jVIH9PTpQo=;
Message-ID: <279129.36717.qm@web27001.mail.ukl.yahoo.com>
X-YMail-OSG: rznU_zYVM1lvHGlHKYyzngH7vuq11rWeuTeaBMLFN2JrfoH
 G4wfGJ2soUohT5t4V1BzqOpxfNhJgN.1vT2qZgiZxno3NdL7d827lgD0eKss
 m7HdBOhLl2rqz.vSqwsmEa2uecKnIHX8_bLRI8ggAukPgOnqcTFkE0n4B_B8
 Lc9qzU2XZGvkGOq01FIL0lqWgmiAVKRnlwS.O0kUYIYd7LCkWfHgiNlUOlsx
 hHobVv_zNDcsveh8yGhSxnAxVu4nCQ.lJ8w7GnqimAQYvQMq6vxsak6EGMjV
 xu6nT847jF1enn3i6phc-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Wed, 4 Aug 2010 22:59:56 +0000 (GMT)
From: bifferos <bifferos@yahoo.co.uk>
Subject: Re: [tip:x86/cpu] x86, cpu: RDC doesn't have CPUID, which is what c_ident is
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        florian@openwrt.org, mark@bifferos.com, tglx@linutronix.de,
        Ingo Molnar <mingo@elte.hu>, linux-tip-commits@vger.kernel.org
In-Reply-To: <4C59CA37.4050509@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Wed, 4/8/10, H. Peter Anvin <hpa@linux.intel.com> wrote:

> 
> Incidentally, please do note that there is no concrete
> benefit to this
> "support", since all it does is replicate information in
> /proc/cpuinfo
> that is already available through lspci.

Without the patch RDC is misreported as Cyrix Cx486SLC.




      
