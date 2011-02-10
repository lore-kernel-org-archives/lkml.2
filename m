Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751309Ab1BJFii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 00:38:38 -0500
Received: from smtp108.prem.mail.sp1.yahoo.com ([98.136.44.63]:25450 "HELO
	smtp108.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751064Ab1BJFih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 00:38:37 -0500
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: BK0N69wVM1lvZqq7_0TSuHnzNY5qwFG6XW8WBX0zsuQhBxB
 jOOTOzLBPk3bYfCId4eyFN6PxemgAj8wJQp1DowqDDKF2hmgEomwboSuxY_U
 lFHnDzjAK3ryMWxU_.w0c24IHQzTfDd5yBzg_ntmD_.eEIJW3.DgkCDzlFtT
 .AGXHwcLaLi7H2wQT2.eLdYxf7tfLego00yA91R9qVUoZ5FjqORLmWbEjo7R
 nJh1daZHcDIUa_pfi1WGsXBq8jnhklQgslwYKv2A9xOqFDL_IUU6Bir5aayl
 gbEzITh380GEXp7szk9zsxd3aRNLwVTinOWVT0UIj
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4D5379DA.2020109@schaufler-ca.com>
Date: Wed, 09 Feb 2011 21:38:34 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        "Sakkinen Jarkko.2 \(EXT-Tieto/Tampere\)" 
	<ext-jarkko.2.sakkinen@nokia.com>,
        Janne Karhunen <Janne.Karhunen@nokia.com>,
        "Reshetova Elena \(Nokia-D/Helsinki\)" <elena.reshetova@nokia.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: [PULL] Smack: please pull for security-testing next
References: <4D346C8E.3080408@schaufler-ca.com> <4D51E188.9090008@schaufler-ca.com> <alpine.LRH.2.00.1102091851030.12310@tundra.namei.org> <4D52936A.6010407@schaufler-ca.com> <alpine.LRH.2.00.1102100852180.18248@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.1102100852180.18248@tundra.namei.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0e0a070d3a47d279de66e08244769556deae2eee:
  Casey Schaufler (1):
        Smack: correct behavior in the mmap hook

are available in the git repository at:

  git://gitorious.org/smack-next/kernel.git next

Casey Schaufler (1):
      Smack: correct final mmap check comparison

Shan Wei (1):
      security:smack: kill unused SMACK_LIST_MAX, MAY_ANY and MAY_ANYWRITE

 security/smack/smack.h     |    8 --------
 security/smack/smack_lsm.c |    2 +-
 2 files changed, 1 insertions(+), 9 deletions(-)
