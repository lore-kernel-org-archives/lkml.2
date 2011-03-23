Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933257Ab1CWUXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 16:23:39 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54660 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932698Ab1CWUXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 16:23:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=kgXbmDLlEgQhOq8PvKNbrDW5nV+4eB9Ytt33EGsAFwLCQ07xIuCs1julxjk8BPi+su
         m2+kbQL0/faHAnQ6JJz8uPMe6CCI+9lKJTs8jAL4OJey8Aik3NLSla8ppW7GlM3Gqt/H
         tVb6eE+BOFrp2lGeyJq3QwotHRq1BjJWw+E7o=
MIME-Version: 1.0
In-Reply-To: <4D8A1BB4.4030709@schaufler-ca.com>
References: <1300840717-4413-1-git-send-email-pekane52@gmail.com>
	<20110322.193206.28821045.davem@davemloft.net>
	<1300895847.28871.13.camel@unknown001a4b0c2895>
	<4D8A1BB4.4030709@schaufler-ca.com>
Date: Wed, 23 Mar 2011 15:23:35 -0500
Message-ID: <AANLkTik55CAKfU5v4PE87h26vwAMy8vV7rhMmu9EA19B@mail.gmail.com>
Subject: Re: [PATCH v2] net/unix: Add secdata to unix_stream msgs
From: Pat Kane <pekane52@gmail.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Eric Paris <eparis@redhat.com>, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        cxzhang@watson.ibm.com, sds@tycho.nsa.gov, jmorris@namei.org,
        eparis@parisplace.org, paul.moore@hp.com,
        LSM <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  >> On Tue, 2011-03-22 at 19:32 -0700, David Miller wrote:
  >>> The SELINUX hook implementations even have "_dgram()" in their names.

The LSM hook that I am having problems with, and that the patch fixes
is  "secid_to_secctx()"  not "socket_getpeersec_dgram()".


Pat
---
