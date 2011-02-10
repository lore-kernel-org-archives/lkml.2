Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370Ab1BJQZF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 11:25:05 -0500
Received: from smtp105.prem.mail.sp1.yahoo.com ([98.136.44.60]:39127 "HELO
	smtp105.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750820Ab1BJQZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 11:25:03 -0500
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: f4PCJq0VM1lE3FdMX004bC1D.HBHHOxot2f9GAK0Mfd1Hg8
 9W2z_gZvaiMt5cnnPwY1iFwXIsODWzdlIqMU6SuK5WsjaZsmuIHnz78nboe3
 OqCfJ0FeeKF7wXCTqGSqiK.espk_sGPiPFjiv_aP3R94EwnAFCFhLaGBBJZd
 FvL6jgN64e6OhTna9ywQluCr0nzgZZm.xinjtO8H8ssavBBkVmYcTuZ0xVBx
 B89GdF.jmI6GayhB4A_wFLgqlAflwsDeAMWVR4N5Hvy23iY4uo2qSN.9qbY5
 szqstqe2.1cCnJP7cghOdDS0LW0nvTXu9Pg--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4D54115C.6090403@schaufler-ca.com>
Date: Thu, 10 Feb 2011 08:25:00 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Eric Paris <eparis@redhat.com>, Don Dutile <ddutile@redhat.com>,
        James Morris <jmorris@namei.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-security-module@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 1/2] security: add cred argument to security_capable()
References: <1297318312-14309-1-git-send-email-chrisw@sous-sol.org> <1297318312-14309-2-git-send-email-chrisw@sous-sol.org> <4D540BCE.5020007@schaufler-ca.com> <20110210160837.GB9869@sequoia.sous-sol.org>
In-Reply-To: <20110210160837.GB9869@sequoia.sous-sol.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/10/2011 8:08 AM, Chris Wright wrote:
> * Casey Schaufler (casey@schaufler-ca.com) wrote:
>> On 2/9/2011 10:11 PM, Chris Wright wrote:
>>> Expand security_capable() to include cred, so that it can be usable in a
>>> wider range of call sites.
>> I'll bite. What to plan to use this for? I wouldn't see this getting
>> accepted on its own without a user. I don't see anything wrong with
>> the change other than that it is not used by anything.
> Casey, the user is in 2/2.

Which didn't show up on the LSM list. I see it now, but
had to go looking. Ok, no worries

> https://lkml.org/lkml/2011/2/10/16
>
>

