Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab1CKNC3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 08:02:29 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49140 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab1CKNC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 08:02:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=UWD1MjjRhanKP+oZp71w1Un2ZVhJeHppJDeNXXENd9h3VDBVlPG5m+aQjPjKnwkKRz
         PSHiSa5VO+HVJHwVTyAsqnfxq5Agzh+xwJ5PD3iKBqXtg2M89OaUAx6MS/vCCt94C7Uo
         vaxiLLUWEC26V0M8EajCzrYTFjz4qwCz6dNko=
MIME-Version: 1.0
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Fri, 11 Mar 2011 10:02:06 -0300
Message-ID: <AANLkTimvdfdqTdSkdPOoH5+Djg2hN+sMA0saWfwQXPmZ@mail.gmail.com>
Subject: Fix misspellings
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

Now I have some time to look to an old patch I've made (
http://kerneltrap.org/mailarchive/linux-kernel/2010/9/7/4616618 ).
I'll split it and send to the respective maintainers. Should I apply
the patches on top of -next?


regards,
Lucas De Marchi
