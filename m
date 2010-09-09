Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab0IILGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 07:06:39 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38236 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314Ab0IILGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 07:06:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Te+mqIukOwL0rd/fhvzlwTjVQ87So6i86hRPbXcxBcahky+VR93RWNI+Rmk8W0cExc
         4s02Depeim2q8ZB6ruVEmpw5pED8G3m4iUOyGY1yqAAdjPbJIs58WCo8WBX2KKruTc+s
         JvecQbtG/FzyBaISb6KAGT6a/gl8wrzwKYixw=
MIME-Version: 1.0
Date: Thu, 9 Sep 2010 13:06:35 +0200
Message-ID: <AANLkTi=yeHyOeewm9tdsHRtj+=d+vE5=NRKGaPyq_yGH@mail.gmail.com>
Subject: perf events over (net) console?
From: Harald Gustafsson <hgu1972@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Song Yuan <song.yuan@ericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We would like to monitor the perf events continuously on a remote
machine. Does it exist a solution (in the kernel) to direct the output
to a console or maybe even a netconsole? We would like to avoid a user
space application to transfer it, due to that the machine will be
running a test which will heavily load it and we want to avoid as many
unrelated user space tasks as possible. If not mainlined does anyone
have a patch for this?

Our purpose is to visualize task's CPU utilization and a few other
events like CPU frequency changes etc in realtime on the remote
machine.

Regards,
  Harald Gustafsson
