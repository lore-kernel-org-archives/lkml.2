Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab0HaVoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 17:44:00 -0400
Received: from smtp-out.google.com ([216.239.44.51]:11215 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382Ab0HaVn6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 17:43:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Dw8DQCXr5Dg/UlPKqx/tQ0/tdLteCPDt9y5kU12Shi1aESGmed2GEgZ1/ZhWgw8nPG
         j2NpZMm4OMURJ1IEG1Sg==
MIME-Version: 1.0
In-Reply-To: <AANLkTinq1Unms=RsJuxGj5iMuU+kt4eHt2fd4niP4Pfg@mail.gmail.com>
References: <AANLkTinq1Unms=RsJuxGj5iMuU+kt4eHt2fd4niP4Pfg@mail.gmail.com>
Date: Tue, 31 Aug 2010 14:43:52 -0700
Message-ID: <AANLkTineOu03ct06CLO-ec2ut-prnWBMbLUN9ZAX1b4W@mail.gmail.com>
Subject: Re: hello, Is there any documentation about CFS and cgroup??
From: Paul Menage <menage@google.com>
To: =?UTF-8?B?7KGw7KCV7Jqx?= <jmanbal@unist.ac.kr>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 2:59 AM, 조정욱 <jmanbal@unist.ac.kr> wrote:
> hello, Is there any documentation about CFS and cgroup??

Try Documentation/cgroups/cgroups.txt and Documentation/scheduler/*

Paul
