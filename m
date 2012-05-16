Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab2EPO0I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 10:26:08 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:64430 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab2EPOZu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 10:25:50 -0400
MIME-Version: 1.0
From: Philipp Riemer <ruderphilipp@gmail.com>
Date: Wed, 16 May 2012 16:25:28 +0200
Message-ID: <CAFU-uVs_Gwacxj74cyekY2gv+zAq+Spba7nfPLdTc_dR3y8CYw@mail.gmail.com>
Subject: [GIT PULL] new mailmap file for the linux kernel git repository
To: Paul Mundt <lethal@linux-sh.org>,
        =?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Jiri Kosina <jkosina@suse.cz>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Wang Chen <ellre923@gmail.com>, Greg KH <greg@kroah.com>,
        Jonathan Corbet <corbet@lwn.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear members of the LKML,
I spent the last weeks creating a new .mailmap file for the LK git
repo (see previous mail attached below).

The new version of this file is available in the git repository at:
  git://github.com/ruderphilipp/linux.git mailmap-changes

Latest commit at the branch: 5b4e7ca5d453bc2701ef79969aecb9ed23abd469
mailmap changes
The following changes since commit 36be50515fe2aef61533b516fa2576a2c7fe7664
 .mailmap | 2479 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 2441 insertions(+), 38 deletions(-)

Patch file in addition below the attached mail.

In my work I considered the following aspects:
* Typos in names
* Typos in mails
* Mapping of ambiguous mail adresses (e.g. {aa@bb.cc, aa@home.bb.cc,
aa@laptop.bb.cc,...} becomes {aa@bb.cc})
* Mapping of names to entries with only email information
* Harmonization of position and style of last name (no more all-caps
names like "First LAST" or those of "Last, First")
* No initials in names if not necessary
* Conversion of email addresses to lower case

Why did I do this? One reason for that is a missing configuration of
Git -- leading to a combination of the name of user (login) and
computer (e.g. "me@mybox.local"). Of course this is not a real mail
address and most users realize and fix this fact pretty fast.
Nevertheless there is at least one commit with wrong data in the
codebase. Another reason is spelling. When skimming through the vast
list of author names and email addresses one can find many
typographical errors such as ".con" instead of ".com" or missing
letters. Over time also these get fixed -- but the wrong data is
visible.

I am pretty confident that I coalesced the data of most of the
ambiguous users. But despite having spent so many hours in finding and
matching these entries, this work (that I did primarily for my thesis)
might be helpful for other researchers as well, such as e.g. Wang Chen
as the maintainer of the Linux Kernel Patch Statistic
<http://www.remword.com/kps_result/> or Greg, Jonthan, etc. as the
authors of "Who writes Linux"
<http://go.linuxfoundation.org/who-writes-linux-2012>...

Hence, please integrate this file into the official Linux Kernel repository.

Regards,
Philipp Riemer

---------- Forwarded message ----------
From: Philipp Riemer
Date: 2012/5/3
Subject: proposal of a new mailmap file for the linux kernel git repository
To: LKML

Dear members of the LKML,
one of the advantages of distributed version systems such as the here
used Git is also the weakness of those: everyone has its own copy of
the repository and there is no authority controlling it (in general).
As a result every developer can use whatever name and email address he
or she wants to use. This leads to the fact that many people have
typos in there names or use ".local" or ".(none)" email addresses.
Hence, Git supports .mailmap files to overcome this and correct known
mistakes.

The .mailmap file of the Linux Kernel consists of around 100 entries
at the moment. Due to my work for my thesis I am currently skim
through all names and email addresses and add ambiguous ones to the
mailmap file as well. This lead to a size of around 2000 lines.

Because this is my first contribution to the Linux Kernel and since
the size of the file is huge compared to most other patches, I want to
ask if I still should post the (patch) file here or if the link to my
GitHub clone (<https://github.com/ruderphilipp/linux>, branch
"mailmap-changes") is enough?
Or should I send the file directly to one maintainer? For the latter,
who would be the best person in this case? Paul Mundt because he
pushed the last changes of this file to the official repository? Wang
Chen as the maintainer of the Linux Kernel Patch Statistic? Or someone
else?

It is not the final version, yet, since I still have around 2.5% (500
of originally around 20000 entries) to analyze. But I would say that
this file is as good as done.

With regards,
Philipp Riemer

PS: I would appreciate if everyone searches for his or her own name in
the list under <https://github.com/ruderphilipp/linux/blob/mailmap-changes/.mailmap>
and corrects it if necessary.

-- 
diff --git a/.mailmap b/.mailmap
index 9b0d026..606ab67 100644
--- a/.mailmap
+++ b/.mailmap
@@ -7,109 +7,2512 @@
 # repo-abbrev: /pub/scm/linux/kernel/git/
 #

+### A #####
 Aaron Durbin <adurbin@google.com>
+Aaro Koskinen <aaro.koskinen@nokia.com>
<Aaro.Koskinen@nokia.com>
+Aaron Lu <aaron.lu@amd.com>                             <Aaron.Lu@amd.com>
+Aaron Young <ayoung@sgi.com>
+Aaron Young <ayoung@sgi.com>
<ayoung@google.engr.sgi.com>
+Aarthi Thiruvengadam <aarthi.thiruvengadam@qca.qualcomm.com>
<athiruve@qca.qualcomm.com>
+Abhijeet Kolekar <abhijeet.kolekar@intel.com>
+Abraham Arce <x0066660@ti.com>
+Achim Leubner <Achim_Leubner@adaptec.com>
+Adam Brooks <adam.j.brooks@gmail.com>                   <From:
jiang.adam@gmail.com>
+Adam Dutko <dutko.adam@gmail.com>
+Adam Jerome <abj@novell.com>
+Adam Moss <adam@gimp.org>
 Adam Oldham <oldhamca@gmail.com>
 Adam Radford <aradford@gmail.com>
+Adam Richter <adam@yggdrasil.com>
+Adam Thomson <adam.thomson@alcatel-lucent.com>
+Adhiraj Joshi <adhiraj@netxen.com>
 Adrian Bunk <bunk@stusta.de>
+Adrian Drzewiecki <adriand@drze.net>                    <z@drze.net>
+Adrian Hunter <adrian.hunter@nokia.com>
<Adrian.Hunter@nokia.com>
+Adrian Hunter <adrian.hunter@nokia.com>
<ext-adrian.hunter@nokia.com>
+Adrian Hunter <adrian.hunter@nokia.com>
<[ext-adrian.hunter@nokia.com]>
+Adrian Taylor <adrian.taylor@realvnc.com>               <aat@realvnc.com>
+Akinbou Mita <akinobu.mita@gmail.com>
<akinobu.mita@gmail..com>
+Alan Brunelle <alan.brunelle@hp.com>                    <Alan.Brunelle@hp.com>
 Alan Cox <alan@lxorguk.ukuu.org.uk>
 Alan Cox <root@hraefn.swansea.linux.org.uk>
+Alan Cox <alan@linux.intel.com>
<alan@linux.jf.intel.com>
+Alan Curry <pacman@theworld.com>                        <pacman@TheWorld.com>
+Alan Nisota <alannisota@gmail.com>                      <anisota@gmail.com>
+Al Cooper <acooper@gmail.com>                           <alcooperx@gmail.com>
+Ajay Kumar Gupta <ajay.gupta@ti.com>
+Akeem Ting <akeem@jmicron.com>
+Akinbou Mita <akinobu.mita@gmail.com>
+Aki Nyrhinen <anyrhine@cs.helsinki.fi>
+Akshay Shankarmurthy <akshay.s@ti.com>
+Alasdair Kergon <agk@redhat.com>
+Albert Cahalan <acahalan@cs.uml.edu>
+Albrecht Dreß <albrecht.dress@lios-tech.com>
+Albrecht Dreß <albrecht.dress@lios-tech.com>
<albrecht.dress@com.rmk.(none)>
+Alek Du <alek.du@intel.com>
+Aleksandr Piskunov <aleksandr.v.piskunov@gmail.com>
+Aleksandr Piskunov <aleksandr.v.piskunov@gmail.com>
<alexandr.v.piskunov@gmail.com>
 Aleksey Gorelov <aleksey_gorelov@phoenix.com>
-Al Viro <viro@ftp.linux.org.uk>
-Al Viro <viro@zenIV.linux.org.uk>
+Aleksey Gorelov <aleksey_gorelov@phoenix.com>
<Aleksey_Gorelov@Phoenix.com>
+Alessandro Rubini <rubini@gnudd.com>                    <rubini-list@gnudd.com>
+Alessandro Zummo <alessandro.zummo@towertech.it>
<azummo-armlinux@towertech.it>
+Alessandro Zummo <alessandro.zummo@towertech.it>        <a.zummo@towertech.it>
+Alessandro Zummo <alessandro.zummo@towertech.it>
<azummo-lists@towertech.it>
+Alexander Chiang <achiang@hp.com>
+Alexander Chiang <achiang@canonical.com>
+Alexander Clouter <alex@digriz.org.uk>
<alex-kernel@digriz.org.uk>
+Alexander Deucher <alexander.deucher@amd.com>
+Alexander Deucher <alexdeucher@gmail.com>
+Alexander Deucher <alexdeucher@gmail.com>               <alex@hp.localdomain>
+Alexander Deucher <alex@botchco.com>
+Alexander Fomichev <git.user@gmail.com>
+Alexander Kurz <akurz@blala.de>                         <linux@blala.de>
+Alexander Lukyanov <lav@netis.ru>
+Alexander Strakh <strakh@ispras.ru>
+Alexander Patrakov <patrakov@ums.usu.ru>
+Alexander Viro <viro@ftp.linux.org.uk>
+Alexander Viro <viro@www.linux.org.uk>
+Alexander Viro <viro@zeniv.linux.org.uk>
<viro@ZenIV.linux.org.uk>
+Alexander Viro <viro@zeniv.linux.org.uk>
<viro@zenIV.linux.org.uk>
+Alexander Viro <viro@parcelfarce.linux.theplanet.co.uk>
+Alexander Viro <viro@hera.kernel.org>
+Alexander Viro <al@aretha.pdmi.ras.ru>
+Alexander Zarochentsev <zam@namesys.com>
+Alexandra Kossovsky <alexandra.kossovsky@oktetlabs.ru>
<Alexandra.Kossovsky@oktetlabs.ru>
+Alexandre Bounine <alexandre.bounine@idt.com>
<Alexandre.Bounine@tundra.com>
+Alexandros Batsakis <alexandros.batsakis@netapp.com>
<Alexandros.Batsakis@netapp.com>
+Alexandros Batsakis <alexandros.batsakis@netapp.com>    <batsakis@netapp.com>
+Alexandru Copot <alex.mihai.c@gmail.com>
+Alex Cheng <alex.cheng@quantatw.com>
<Alex.Cheng@quantatw.com>
+Alexey Korolev <akorolev@infradead.org>
<akorolev@pentafluge.infradead.org>
+Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>                 <kaber@ms2.inr.ac.ru>
+Alexey Rytchkov <lilo0@nm.ru>
+Alexey Starikovskiy <astarikivskiy@suse.de>
+Alexey Starikovskiy <astarikovskiy@suse.de>             <astarikivskiy@suse.de>
+Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
+Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
<alexey_y_starikovskiy@linux.intel.com>
+Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
<alexey.y.starikovskiy@linux.intel.com>
+Alex Kovich <alevkovich@tut.by>
+Alex Raimondi <raimondi@miromico.ch>
<mailinglist@miromico.ch>
+Alex Shi <alex.shi@intel.com>
+Alex Smirnov <alex.bluesman.smirnov@gmail.com>
+Alex Villacís Lasso <a_villacis@palosanto.com>
+Ali Ayoub <ali@mellanox.co.il>
<ali@dev.mellanox.co.il>
+Alim Akhtar <alim.akhtar@samsung.com>
+Allan Stephens <allan.stephens@windriver.com>
<Allan.Stephens@windriver.com>
+Allen Kay <allen.m.kay@intel.com>
+Almer Tigelaar <almer@gnome.org>
+Alok Kataria <akataria@vmware.com>
+Alok Kataria <alokk@calsoftinc.com>
+Alon Ziv <alonz@nolaviz.org>                            <alon+git@nolaviz.org>
+Amir Goldstein <amir73il@users.sf.net>
<amir73il@users.sourceforge.net>
+Amit Arora <aarora@in.ibm.com>
<aarora@linux.vnet.ibm.com>
+Amit Kale <amitkale@netxen.com>
+Amit Kumar Salecha <amit.salecha@qlogic.com>
+Amit Kumar Salecha <amit.salecha@qlogic.com>            <amit@qlogic.com>
+Amit Kumar Salecha <amit.salecha@qlogic.com>            <amit@unm84.unmin.com>
+Amit Kumar Salecha <amit@netxen.com>                    <amit@dut4146.(none)>
+Amon Ott <a.ott@m-privacy.de>                           <ao@m-privacy.de>
+Amul Saha <amul.saha@samsung.com>
+Ananda Raju <ananda.raju@neterion.com>
<Ananda.Raju@neterion.com>
+Anand Avati <avati@gluster.com>
+Anand Gadiyar <gadiyar@ti.com>
+Anand Gadiyar <gadiyar@ti.com>                          <adiyar@ti.com>
+Anand Sawant <sawant@ti.com>
+Anantha Narayanan <anantha.narayanan@intel.com>
+Ananth Mavinakayanahalli <ananth@in.ibm.com>
+Ananth Mavinakayanahalli <amavin@redhat.com>
+Anders Franzen <anders.franzen@ericsson.com>
<Anders.Franzen@ericsson.com>
+Anders Kaseorg <andersk@mit.edu>                        <andersk@MIT.EDU>
+Anders Kaseorg <andersk@ksplice.com>                    <[andersk@ksplice.com]>
+Andi Kleen <ak@suse.de>
<andi@basil.nowhere.org>
+Andi Kleen <ak@suse.de>                                 <andi@one.(none)>
+Andiry Xu <andiry.xu@amd.com>
+Andrea Amorosi <andrea.amorosi76@gmail.com>
<Andrea.Amorosi76@gmail.com>
+Andrea Odetti <mariofutire@gmail.com>
<mariofutire@googlemail.com>
+Andreas Bießmann <andreas@biessmann.de>
+Andreas Fenkart <andreas.fenkart@streamunlimited.com>
 Andreas Herrmann <aherrman@de.ibm.com>
+Andreas Herrmann <andreas.herrmann3@amd.com>
+Andreas Hübner <andreas@k4n.de>
+Andreas Krebbel <andreas.krebbel@de.ibm.com>
<Andreas.Krebbel@de.ibm.com>
+Andreas Krebbel <andreas.krebbel@de.ibm.com>            <krebbel1@de.ibm.com>
+Andreas Krebbel <andreas.krebbel@de.ibm.com>
<krebbel@linux.vnet.ibm.com>
+Andreas Mohr <andi@rhlx01.fht-esslingen.de>
<[andi@rhlx01.fht-esslingen.de]>
+Andreas Schwab <schwab@suse.de>                         <scwhab@suse.de>
+Andre Bartke <andre.bartke@gmail.com>
<andre.bartke@googlemail.com>
+André Carvalho de Matos <andre.carvalho.matos@stericsson.com>
+André Goddard Rosa <andre.goddard@gmail.com>
+Andrei Konovalov <akonovalov@mvista.com>
<akonovalov@ru.mvista.com>
+Andre Oliveira <anbadeol@gmail.com>
+André Schenk <andre@melior.s.bawue.de>
+Andrew Bird <ajb@spheresystems.co.uk>
+Andrew Bird <ajb@spheresystems.co.uk>
<ajb@spheresytems.co.uk>
+Andrew Bishop <amb@gedanken.demon.co.uk>
+Andrew de Quincey <adq_dvb@lidskialf.net>               <quincy@linuxtv.org>
+Andrew Harvey <agh@cisco.com>
+Andrew Hendry <andrew.hendry@gmail.com>
+Andrew Lutomirski <luto@mit.edu>
+Andrew Lutomirski <luto@mit.edu>                        <luto@MIT.EDU>
 Andrew Morton <akpm@osdl.org>
+Andrew Morgan <morgan@kernel.org>
+Andrew Neporada <nepal@asplinux.ru>
+Andrew Richter <richtera@us.ibm.com>
+Andrew Shadoura <andrew@beldisplaytech.com>
 Andrew Vasquez <andrew.vasquez@qlogic.com>
+Andrey Melnikoff <temnota@kmv.ru>
+Andrey Mirkin <amirkin@sw.ru>                           <(amirkin@sw.ru)>
+Andrey Yurovsky <andrey@cozybit.com>
+Andrey Yurovsky <andrey@cozybit.com>                    <andrey@slug.(none)>
+Andries Brouwer <andries.brouwer@cwi.nl>
<Andries.Brouwer@cwi.nl>
 Andy Adamson <andros@citi.umich.edu>
+Andy Currid <acurrid@nvidia.com>                        <ACurrid@nvidia.com>
+Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
+Aneesh Kumar <aneesh.kumar@gmail.com>
+Anfei Zhou <anfei.zhou@gmail.com>
+Angelo Castellani <angelo.castellani@gmail.com>
+Angelo Castellani <angelo.castellani@gmail.com>
<angelo.castellani+lkml@gmail.com>
+Angelo Castellani <angelo.castellani@gmail.com>
<angelo.castellani@gmail.con>
+Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
+Anil Kumar <anilkumar@ti.com>
+Anil Kumar <anilkumar@ti.com>                           <anil@ti.com>
+Anirban Sinha <asinha@zeugmasystems.com>
<ASinha@zeugmasystems.com>
+Anish Kumar <anish198519851985@gmail.com>
+Anna Fischer <anna.fischer@hp.com>
+Anoop P A <anoop.pa@gmail.com>
<paanoop1@paanoop1-desktop.(none)>
+Anthony Xu <anthony.xu@intel.com>
+Anton Blanchard <antonb@au1.ibm.com>                    <anton@au1.ibm.com>
+Anton Boyarshinov <boyarsh@altlinux.org>
+Antonino Daplas <adaplas@gmail.com>
+Antonino Daplas <adaplas@pol.net>
+Antonino Daplas <adaplas@hotpop.com>
+Anton Wöllert <a.woellert@gmail.com>
+Anton Vorontsov <avorontsov@mvista.com>
<avorontsov@ru.mvista.com>
+Anton Vorontsov <anton.vorontsov@linaro.org>            <cbou@ru.rmk.(none)>
+Anthony Perard <anthony.perard@citrix.com>
+Anthony Godshall <agodshall@ampro.com>
+Antti Kaijanmäki <antti.kaijanmaki@nomovok.com>
+Antti Seppälä <a.seppala@gmail.com>
+Antti Seppälä <a.seppala@gmail.com>
<a.seppala+linux-dvb@gmail.com>
 Archit Taneja <archit@ti.com>
+Aric Blumer <aric@sdgsystems.com>
+Arend van Spriel <arend@broadcom.com>
<arend@LB-BUN-53.bun.broadcom.com>
+Aristeu Rozanski <aris@redhat.com>                      <arozansk@redhat.com>
+Aristeu Rozanski <aris@ruivo.org>
+Aristeu Rozanski <aris@cathedrallabs.org>
+Aristeu Rozanski <aris@conectiva.com.br>
+Aristeu Rozanski <aristeu.sergio@gmail.com>
+Arjan van de Ven <arjan@linux.intel.com>                <arjan@Linux.intel.com>
+Arjan van de Ven <arjan@linux.intel.com>                <arjan@intel.linux.com>
+Armando Visconti <armando.visconti@st.com>
+Armin Reese <armin.c.reese@intel.com>
+Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
<acme@felicio.ghostprotocols.net>
+Arnaud Mazin <arnaud.mazin@gmail.com>
 Arnaud Patard <arnaud.patard@rtp-net.org>
 Arnd Bergmann <arnd@arndb.de>
+Arnd Bergmann <arndb@de.ibm.com>                        <abergman@de.ibm.com>
+Arnd Bergmann <arndb@de.ibm.com>
<arnd.bergmann@de.ibm.com>
+Arnd Bergmann <arndb@de.ibm.com>                        <arnd@relay.de.ibm.com>
+Arnd Bergmann <arnd@arndb.de>                           <arnd@klappe.arndb.de>
+Arnd Bergmann <arnd@arndb.de>                           <arnd@klappe2.(none)>
+Arnd Hannemann <hannemann@nets.rwth-aachen.de>
<hannemann@i4.informatik.rwth-aachen.de>
+Arnout Vandecappelle <arnout@mind.be>
+Artem Bityutskiy <dedekind@infradead.org>
+Artem Bityutskiy <artem.bityutskiy@nokia.com>
<Artem.Bityutskiy@nokia.com>
+Artem Bityutskiy <artem.bityutskiy@intel.com>
<Artem.Bityutskiy@intel.com>
+Artem Bityutskiy <artem.bityutskiy@intel.com>
<artem.bityutskiy@linux.intel.com>
+Artem Bityutskiy <artem.bityutskiy@intel.com>
<Artem.Bityutskiy@linux.intel.com>
+Artem Bityutskiy <dedekind@infradead.org>
+Artem Bityutskiy <dedekind@linutronix.de>
+Artem Bityutskiy <dedekind@sauron.oktetlabs.ru>
+Artem Bityutskiy <dedekind1@gmail.com>
+Arun Bharadwaj <arun@linux.vnet.ibm.com>
+Arun Edarath <arunedarath@mistralsolutions.com>
+Arun Edarath <arun.edarath@gmail.com>
+Arun Sharma <arun.sharma@google.com>                    <aruns@google.com>
+Arvid Jaar <arvidjaar@mail.ru>
+Arvo Järve <arvo@softshark.ee>
+Ashish Jangam <ashish.jangam@kpitcummins.com>
+Ashish Kalra <ashish.kalra@freescale.com>
+Ashish Kalra <ashish.kalra@freescale.com>
<Ashish.Kalra@freescale.com>
+Ashok Raj <ashok.raj@intel.com>                         <Ashok.Raj@intel.com>
+Atsushi Sakai <sakaia@jp.fujitsu.com>
+Aubrey Li <aubrey.li@analog.com>                        <aubreylee@gmail.com>
+August Huber <gus@pbx.org>
+Auke-Jan Kok <auke-jan.h.kok@intel.com>
+Auke-Jan Kok <auke-jan.h.kok@intel.com>
<auke\-jan.h.kok@intel.com>
+Auke-Jan Kok <auke-jan.h.kok@intel.com>
<auke\\-jan.h.kok@intel.com>
+Auke-Jan Kok <auke-jan.h.kok@intel.com>
<auke\\\-jan.h.kok@intel.com>
+Auke-Jan Kok <auke-jan.h.kok@intel.com>
<juke-jan.h.kok@intel.com>
+Auke-Jan Kok <auke-jan.h.kok@intel.com>                 <ahkok@gitlost.site>
+Auke-Jan Kok <sofar@foo-projects.org>
+Austin Zhang <austin.zhang@intel.com>
<austin_zhang@linux.intel.com>
+Avinash H.M <avinashhm@ti.com>
 Axel Dyks <xl@xlsigned.net>
+Axel Köllhofer <axelkoellhofer@web.de>                  <AxelKoellhofer@web.de>
 Axel Lin <axel.lin@gmail.com>
+Axel Lin <axel.lin@gmail.com>                           <[axel.lin@gmail.com]>
+A. Yoshiyama <yosshy@debian.or.jp>
+
+### B #####
+Babu Moger <babu.moger@netapp.com>                      <Babu.Moger@netapp.com>
+Babu Moger <babu.moger@lsi.com>                         <Babu.Moger@lsi.com>
+Balaji T K <balajitk@ti.com>
+Balbir Singh <balbir@linux.vnet.ibm.com>                <balbir@in.ibm.com>
+Bandan Das <bandan.das@stratus.com>
<bandan.das@Stratus.com>
+Barry Song <barry.song@analog.com>                      <Barry.Song@analog.com>
+Barry Song <baohua.song@csr.com>                        <Baohua.Song@csr.com>
+Barry Song <baohua.song@csr.com>                        <Barry.Song@csr.com>
+Barry Song <baohua.song@csr.com>                        <bs14@csr.com>
+Bart Hartgers <bart.hartgers@gmail.com>
+Bartlomiej Zolnierkiewicz <bzolnier@elka.pw.edu.pl>
<B.Zolnierkiewicz@elka.pw.edu.pl>
+Bauke Jan Douma <bjdouma@xs4all.nl>
+Becky Bruce <becky.bruce@freescale.com>                 <bgill@freescale.com>
+Ben Cahill <ben.m.cahill@intel.com>
+Ben Castricum <lk0806@bencastricum.nl>                  <lk08@bencastricum.nl>
+Ben Collins <bcollins@ubuntu.com>
<ben.collins@ubuntu.com>
+Ben Collins <bcollins@debian.org>
+Ben Dooks <ben@fluff.org>                               <ben@fluff.org.uk>
+Ben Dooks <ben@fluff.org>
<ben-linux@org.rmk.(none)>
+Ben Dooks <ben@fluff.org>                               <ben-linux@fluff.org>
+Ben Dooks <ben@fluff.org>
<ben-linux-usb@fluff.org>
+Ben Dooks <ben@fluff.org>                               <ben-netdev@fluff.org>
+Ben Dooks <ben@fluff.org>                               <ben-lkinux@fluff.org>
+Ben Dooks <ben@fluff.org>                               <ben@trinity.fluff.org>
+Ben Dooks <ben@fluff.org>                               <ben-mtd@fluff.org>
+Ben Dooks <ben@fluff.org>
<ben-linux-arm@fluff.org>
+Ben Dooks <ben@fluff.org>                               <ben-fbdev@fluff.org>
+Ben Dooks <ben@fluff.org>                               <ben-alsa@fluff.org>
+Ben Dooks <ben@fluff.org>
<ben@ben-laptop.fluff.org>
+Ben Gamari <bgamari.foss@gmail.com>                     <bgamari@gmail.com>
 Ben Gardner <bgardner@wabtec.com>
-Ben M Cahill <ben.m.cahill@intel.com>
-Björn Steinbrink <B.Steinbrink@gmx.de>
+Ben Gardner <bgardner@wabtec.com>                       <BGardner@Wabtec.com>
+Ben Herrenschmidt <benh@kernel.crashing.org>            <Ben
Herrenschmidt benh@kernel.crashing.org>
+Benjamin LaHaise <bcrl@linux.intel.com>
<benjamin.c.lahaise@intel.com>
+Benjamin Zores <benjamin.zores@alcatel-lucent.com>
<benjamin.zores@alcatel-lucent.fr>
+Ben Myers <bpm@sgi.com>
+Ben Nizette <bn@niasdigital.com>                        <ben@niasdigital.com>
+Ben Nizette <ben.nizette@iinet.net.au>
+Benny Halevy <bhalevy@panasas.com>
<bhalevy@fs1.bhalevy.com>
+Benny Halevy <bhalevy@tonian.com>                       <benny@tonian.com>
+Boissinot <bboissin@gmail.com>                   <bboissin+ipw2100@gmail.com>
+Benoît Cousson <b-cousson@ti.com>
+Benoit Papillault <benoit.papillault@free.fr>
+Bernard Pidoux <f6bvp@free.fr>
+Bernd Porr <berndporr@f2s.com>                          <BerndPorr@f2s.com>
+Bernhard Link <brlink@debian.org>
+Bernhard Rosenkraenzer <br@blankpage.ch>
+Bert Hubert <bert.hubert@netherlabs.nl>
+Bhanu Prakash Gollapudi <bprakash@broadcom.com>
+Bharata Rao <bharata@linux.vnet.ibm.com>
+Bhavesh Davda <bhavesh@avaya.com>
+Bibo Mao <bibo.mao@intel.com>
+Bibo Mao <bibo.mao@intel.com>
<bibo_mao@linux.intel.com>
+Bill Huey <billh@gnuppy.monkey.org>
+Bill Jordan <bjordan@rajant.com>                        <bjordan@ig88.(none)>
+Bill Moss <bmoss@clemson.edu>                           <bmoss@CLEMSON.EDU>
+Bill Pemberton <wfp5p@virginia.edu>
<wfp5p@viridian.itc.virginia.edu>
+Björn Fay <mail@bfay.de>
+Björn Forsman <bjorn.forsman@gmail.com>
+Björn Gerhart <oss@extracloud.de>
+Bjorn Helgaas <bjorn.helgaas@hp.com>
+Bjorn Helgaas <bjorn.helgaas@hp.com>
<bjorn.helgaas at hp.com>
+Björn Krombholz <fox.box@gmail.com>
+Bjørn Mork <bjorn@mork.no>
+Björn Smedman <bjorn.smedman@venatech.se>
+Björn Steinbrink <b.steinbrink@gmx.de>                  <B.Steinbrink@gmx.de>
+Boaz Harrosh <bharrosh@panasas.com>
+Boaz Harrosh <bharrosh@panasas.com>                     <Boaz Harrosh
bharrosh@panasas.com>
+Bob Copeland <me@bobcopeland.com>                       <bob@hash.(none)>
+Bob Liu <lliubbo@gmail.com>                             <yjfpb04@gmail.com>
+Bob Nelson <rrnelson@us.ibm.com>
<rrnelson@linux.vnet.ibm.com>
+Bob Picco <bob.picco@hp.com>
+Boqun Feng <boqun.feng@intel.com>
+Borislav Petkov <petkovbb@gmail.com>
<petkovbb@googlemail.com>
+Borislav Petkov <borislav.petkov@amd.com>               <bp@amd64.org>
+Boris Ostrovsky <boris.ostrovsky@amd.com>               <ostr@amd64.org>
+Bo Yang <bo.yang@lsi.com>
+Bo Yang <bo.yang@lsi.com>                               <Bo.Yang@lsi.com>
+Bo Yang <boyang1288@gmail.com>
+Bo He <bo.he@intel.com>
+Brandon Black <blblack@gmail.com>
+Brandon Philips <brandon@ifup.org>
+Brandon Philips <bphilips@suse.de>
+Brajesh Dave <brajeshd@marvell.com>
+Breno Leitão <leitao@linux.vnet.ibm.com>
+Breno Leitão <leitao@linux.vnet.ibm.com>                <breno@cafe.(none)>
+Brett Russ <russb@emc.com>
+Brett Warden <brett.warden@gmail.com>
 Brian Avery <b.avery@hp.com>
-Brian King <brking@us.ibm.com>
+Brian Haley <brian.haley@hp.com>                        <Brian.Haley@hp.com>
+Brian Julin <bri@abrij.org>
+Brian King <brking@linux.vnet.ibm.com>                  <brking@us.ibm.com>
+Brian King <brking@charter.net>
+Brian Merrell <bgmerrell@novell.com>
+Brian Murphy <brm@murphy.dk>                            <brian@murphy.dk>
+Brian Tarricone <brian@tarricone.org>
+Brian Uhrain <buhrain@rosettastone.com>
+Brice Goglin <brice@myri.com>
+Brice Goglin <brice.goglin@ens-lyon.org>
<Brice.Goglin@ens-lyon.org>
+Brice Goglin <brice.goglin@inria.fr>                    <Brice.Goglin@inria.fr>
+Brilly Wu <brillywu@viatech.com.cn>
<BrillyWu@viatech.com.cn>
+Bruce Allan <bruce.w.allan@intel.com>
+Bruce Losure <blosure@americas.sgi.com>                 <blosure@sgi.com>
+Bruce Robertson <bruce.e.robertson@intel.com>
+Bruno Braga <bruno.braga@gmail.com>
+Bruno Prémont <bonbons@linux-vserver.org>
+Bruno Randolf <br1@einfach.org>
+Bruno Randolf <br1@thinktube.com>                       <bruno@thinktube.com>
+Bryn M. Reeves <bmr@redhat.com>                         <breeves@redhat.com>
+
+### C #####
+Calin Culianu <calin@ajvar.org>
+Carl Love <cel@us.ibm.com>                              <carll@us.ibm.com>
+Carl Love <cel@us.ibm.com>
<cel@linux.vnet.ibm.com>
+Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
+Carlos Mafra <crmafra@aei.mpg.de>
+Carlos Mafra <crmafra@gmail.com>
+Carlos Mafra <crmafra@gmail.com>                        <crmafra2@gmail.com>
+Carlos O'Donell <carlos@systemhalted.org>
+Carlos Sánchez Acosta <csanchez@neurowork.net>
+Carlos Ugarte <carlos.e.ugarte.1@gsfc.nasa.gov>
<Carlos.E.Ugarte.1@gsfc.nasa.gov>
+Carmelo Amoroso <carmelo.amoroso@st.com>
+Carsten Emde <c.emde@osadl.org>                         <C.Emde@osadl.org>
+Carsten Emde <c.emde@osadl.org>
<Carsten.Emde@osadl.org>
+Carsten Otte <carsteno@de.ibm.com>                      <cotte@de.ibm.com>
+Casey Schaufler <casey@schaufler-ca.com>
<cschaufler@cschaufler-intel.(none)>
+Catalin Boie <catab@embedromix.ro>
+Catalin Boie <util@deuroconsult.ro>
+Catalin Marinas <catalin.marinas@arm.com>
<catalin.marinas@com.rmk.(none)>
+Chaithrika U S <chaithrika@ti.com>
+Chandra Shekhar <x0044955@ti.com>
+Chaohong Guo <minskey.guo@sun.com>                      <Minskey.Guo@Sun.COM>
+Chaoming Li <chaoming_li@realsil.com.cn>
+Charulatha Varadarajan <charu@ti.com>
+Chas Williams <chas@cmf.nrl.navy.mil>
+Chenhui Zhao <chenhui.zhao@freescale.com>
+Chen-Li Tien <cltien@gmail.com>
+Chen-Li Tien <cltien@cmedia.com.tw>
+Chetan Loke <loke.chetan@gmail.com>
+Chien-Chia Chen <machen@novell.com>
+Chien-Chia Chen <machen@suse.com>
+Chris Arges <arges@linux.vnet.ibm.com>
+Chris Baugher <baugher@enteract.com>
+Chris Conger <chris.a.conger@saic.com>
<CHRIS.A.CONGER@saic.com>
+Chris Leech <christopher.leech@linux.intel.com>
<christopher.leech@intel.com>
+Chris Mason <chris.mason@oracle.com>                    <Chris Mason
chris.mason@oracle.com>
+Chris McDermott <lcm@linux.vnet.ibm.com>                <lcm@us.ibm.com>
+Chris Schimp <silverchris@gmail.com>
+Christian Borntraeger <cborntra@de.ibm.com>             <borntrae@de.ibm.com>
+Christian Borntraeger <cborntra@de.ibm.com>
<borntraeger@de.ibm.com>
+Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
<qy03fugy@stud.informatik.uni-erlangen.de>
+Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>        <ehrhardt@de.ibm.com>
+Christian Engelmayer <christian.engelmayer@frequentis.com>
<Christian.Engelmayer@frequentis.com>
+Christian Hesse <mail@earthworm.de>                     <list@eworm.de>
+Christian König <deathsimple@vodafone.de>
+Christian Lamparter <chunkeey@gmail.com>
<chunkeey@googlemail.com>
+Christine Caulfield <christine.caulfield@gmail.com>
<christine.caulfield@googlemail.com>
+Christophe de Dinechin <christophe.de-dinechin@hp.com>
+Christoph Egger <siccegge@cs.fau.de>
<siccegge@stud.informatik.uni-erlangen.de>
+Christophe Jaillet <christophe.jaillet@wanadoo.fr>
<jaillet.christophe@wanadoo.fr>
+Christophe Leroy <christophe.leroy@c-s.fr>
+Christophe Lucas <clucas@ifrance.com>                   <c.lucas@ifrance.com>
+Christopher Arges <christopherarges@gmail.com>
+Christopher Pascoe <linuxdvb@itee.uq.edu.au>
<c.pascoe@itee.uq.edu.au>
+Christopher PeBenito <cpebenito@tresys.com>
+Christopher Rogers <christopher.halse.rogers@canonical.com>
+Christopher Smith <chris.smith@st.com>
 Christoph Hellwig <hch@lst.de>
+Christoph Hellwig <hch@lst.de>                          <hch>
+Christoph Hellwig <hch@lst.de>                          <Christoph Hellwig>
+Christoph Hellwig <hch@lst.de>                          <hch@brick.lst.de>
+Christoph Hellwig <hch@lst.de>                          <hch@serles.lst.de>
+Christoph Hellwig <hch@lst.de>                          <root@serles.lst.de>
+Christoph Hellwig <hch@sgi.com>                         <hch@melbourne.sgi.com>
+Christoph Lameter <clameter@sgi.com>
+Christoph Lameter <clameter@sgi.com>                    <christoph@sgi.com>
+Christoph Lameter <clameter@sgi.com>                    <clameter@engr.sgi.com>
+Christoph Lameter <clameter@sgi.com>
<clameter@schroedinger.engr.sgi.com>
+Christoph Lameter <clameter@sgi.com>
<christoph@stapp.engr.sgi.com>
+Chris Zankel <chris@zankel.net>                         <czankel@Athlon.(none)>
+Chris Zankel <chris@zankel.net>                         <czankel@speedy.(none)>
+Chuansheng Liu <chuansheng.liu@intel.com>
+Chuck Lever <chuck.lever@oracle.com>
<chuck.lever@ORACLE.COM>
+Chuck Meade <chuck@theptrgroup.com>                     <chuck@ThePTRGroup.com>
+Chun-Yi Lee <jlee@novell.com>
+Chun-Yi Lee <jlee@suse.com>
 Corey Minyard <minyard@acm.org>
+Chuanxiao Dong <chuanxiao.dong@intel.com>
+Cindy Kao <cindy.h.kao@intel.com>
+Cindy Kao <cindy.h.kao@intel.com>
<evans@localhost.localdomain>
+Clelia Korol <cvkorol@gmail.com>
+Cliff Wickman <cpw@sgi.com>
+Colin King <colin.king@canonical.com>
+Colin McCabe <colin@cozybit.com>
+Colin Macdonald <cbm@m.fsf.org>
+Colin Tuckley <colin.tuckley@arm.com>                   <Colin.Tuckley@arm.com>
+Coly Li <coly.li@suse.de>                               <coyli@suse.de>
+Corbin Simpson <mostawesomedude@gmail.com>
<MostAwesomeDude@gmail.com>
+Corentin Chary <corentincj@iksaif.net>
+Corentin Labbe <corentin.labbe@geomatys.fr>
+Cornelia Huck <cornelia.huck@de.ibm.com>                <cohuck@de.ibm.com>
+Cornelia Huck <cornelia.huck@de.ibm.com>                <huckc@de.ibm.com>
+Cory Tusar <ctusar@videon-central.com>
+Craig Nadler <craig@nadler.us>
+Cyrill Gorcunov <gorcunov@gmail.com>
+
+### D #####
+Daisuke Hatayama <d.hatayama@jp.fujitsu.com>
+##Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
<d-nishimura@mtf.biglobe.ne.jp>
 Damian Hobson-Garcia <dhobsong@igel.co.jp>
+Damir Abdullin <damir@mimas.ru>
+Dan Aloni <da-x@monatomic.org>                          <da\\-x@monatomic.org>
+Dan Carpenter <error27@gmail.com>                       <[error27@gmail.com]>
+Daniel Berrange <berrange@redhat.com>
+Daniel Blueman <daniel@numascale-asia.com>
+Daniel Blueman <daniel.blueman@gmail.com>
+Daniel Blueman <daniel@quora.org>
+Daniel Borkmann <danborkmann@iogearbox.net>
+Daniel Chen <crimsun@ubuntu.com>
+Daniel Chen <seven.steps@gmail.com>
+Daniele Lacamera <root@danielinux.net>                  <(root at
danielinux.net)net>
+Daniel Engel <dengel@sourceharvest.com>
+Daniel Glöckner <dg@emlix.com>
+Daniel Halperin <daniel.c.halperin@intel.com>
+Daniel Halperin <dhalperi@cs.washington.edu>
+Daniel Mack <daniel@caiaq.de>                           <daniel@caiaq.org>
+Daniel Marjamäki <daniel.marjamaki@comhem.se>
+Daniel Marjamäki <danielm77@spray.se>
+Daniel Thompson <daniel.thompson@st.com>
+Daniel Vetter <daniel.vetter@ffwll.ch>                  <daniel@ffwll.ch>
+Dan Liang <dan.liang@atmel.com>                         <Dan.Liang@atmel.com>
+Dann Frazier <dann.frazier@canonical.com>
+Dann Frazier <dannf@dannf.org>
+Dann Frazier <dannf@hp.com>
+Dann Frazier <dannf@debian.org>
+Danny Tholen <obiwan@mailmij.org>                       <danny@mailmij.org>
+Dario Faggioli <raistlin@linux.it>
+Dariusz Marcinkiewicz <D.Marcinkiewicz@elka.pw.edu.pl>
+Darrel Goeddel <dgoeddel@trustedcs.com>
<dgoeddel@TrustedCS.com>
+Darren Hart <dvhart@linux.intel.com>                    <dvhltc@us.ibm.com>
+Darren Jenkins <darrenrjenkins@gmail.com>
<darrenrjenkins@gmailcom>
+Darrick Wong <djwong@us.ibm.com>
+Dave Airlie <airlied@redhat.com>
+Dave Airlie <airlied@redhat.com>                        <airlied@linux.ie>
+Dave Airlie <airlied@redhat.com>
<airlied@starflyer.(none)>
+Dave Airlie <airlied@redhat.com>
<airlied@optimus.localdomain>
+Dave Airlie <airlied@redhat.com>
<airlied@optimus.(none)>
+Dave Airlie <airlied@redhat.com>                        <airlied@itt42.(none)>
+Dave Airlie <airlied@redhat.com>
<airlied@ppcg5.localdomain>
+Dave Airlie <airlied@redhat.com>
<airlied@davers480.(none)>
+Dave Airlie <airlied@redhat.com>                        <airlied@gmail.com>
+Dave Boutcher <boutcher@cs.umn.edu>
+Dave Boutcher <sleddog@us.ibm.com>
+David Alan Gilbert <linux@treblig.org>
+Dave Graham <david.graham@intel.com>
+Dave Hansen <dave@linux.vnet.ibm.com>                   <haveblue@us.ibm.com>
+Dave Johnson <djohnson@sw.starentnetworks.com>
<djohnson+linux-kernel@sw.starentnetworks.com>
+Dave Johnson <djohnson@sw.starentnetworks.com>
<djohnson+linux-mips@sw.starentnetworks.com>
+Dave Kleikamp <shaggy@linux.vnet.ibm.com>               <shaggy@austin.ibm.com>
+Dave Kleikamp <dave.kleikamp@oracle.com>
<shaggy@kleikamp.(none)>
+Dave Liu <daveliu@freescale.com>                        <DaveLiu@freescale.com>
+Dave Müller <dave.mueller@gmx.ch>
+Dave Rientjes <rientjes@google.com>
+Dave Wysochanski <davidw@netapp.com>
 David Brownell <david-b@pacbell.net>
-David Woodhouse <dwmw2@shinybook.infradead.org>
+David Chosrova <david.chosrova@libertysurf.fr>
+David Choi <david.choi@micrel.com>                      <David.Choi@Micrel.Com>
+David Cohen <david.cohen@nokia.com>
+David Decotigny <decot@google.com>
<david.decotigny@google.com>
+David Fries <david@fries.net>                           <David@Fries.net>
+David Gibson <david@gibson.dropbear.id.au>
<hermes@gibson.dropbear.id.au>
+David Gilbert <linux@treblig.org>
+David Gilbert <david.gilbert@linaro.org>
+David Graham <david.graham@intel.com>
+David Griego <dgriego@mvista.com>
+David Grimes <dgrimes@navisite.com>
+David Härdeman <david@hardeman.nu>
+David Härdeman <david@2gen.com>
+David Howells <bywayofJesseBarnesjbarnes@virtuousgeek.org>
<bywayofjessebarnesjbarnes@virtuousgeek.org>
+David Howells <dhowells@redhat.com>
<dhowells@warthog.cambridge.redhat.com>
+David Keck <david.keck@amd.com>
+David Kilroy <kilroyd@gmail.com>
<kilroyd@googlemail.com>
+David Lamparter <equinox@diac24.net>                    <lists@diac24.net>
+Davidlohr Bueso <dave@gnu.org>
+David Marlin <dmarlin@redhat.com>
+David Micon <DMicon@pelco.com>
+David Miller <davem@davemloft.net>
+David Miller <davem@davemloft.net>
<davem@sunset.davemloft.net>
+David Miller <davem@davemloft.net>
<davem@outer-richmond.davemloft.net>
+David Miller <davem@davemloft.net>
<davem@t1000.davemloft.net>
+David Miller <davem@davemloft.net>
<davem@ultra5.davemloft.net>
+David Miller <davem@davemloft.net>
<davem@hutch.davemloft.net>
+David Miller <davem@davemloft.net>
<davem@bnsf.davemloft.net>
+David Miller <davem@davemloft.net>
<davem@goma.davemloft.net>
+David Miller <davem@davemloft.net>
<davem@huronp11.davemloft.net>
+David Miller <davem@davemloft.net>
<davem@conan.davemloft.net>
+David Miller <davem@davemloft.net>
<davem@zippy.davemloft.net>
+David Miller <davem@davemloft.net>
<davem@drr.davemloft.net>
+David Miller <davem@davemloft.net>                      <davem@kimchee.(none)>
+David Miller <davem@davemloft.net>                      <davem@nuts.(none)>
+David Miller <davem@sunset.sfo1.dsl.speakeasy.net>
+David Moore <dcm@mit.edu>                               <dcm@MIT.EDU>
+David Mosberger-Tang <David.Mosberger@acm.org>
<david.mosberger@acm.org>
+David Mosberger-Tang <davidm@hpl.hp.com>
<davidm@napali.hpl.hp.com>
+David Müller <d.mueller@elsoft.ch>
+David Niemi <dniemi@verisign.com>
+David Quigley <dpquigl@tycho.nsa.gov>
+David Reed <dpreed@reed.com>
+David Richter <richterd@citi.umich.edu>
+David Schleef <ds@schleef.org>
+David Somayajulu <david.somayajulu@qlogic.com>
+David Stevens <dlstevens@us.ibm.com>
+David Täht <d@teklibre.com>
+David Turner <dgturner@iee.org>
+David VomLehn <dvomlehn@cisco.com>
+David Ward <david.ward@ll.mit.edu>
+David Wilder <dwilder@us.ibm.com>
+David Wong <davidtlwong@gmail.com>
+David Woo <xinhua_wu@realsil.com.cn>
+David Woodhouse <david.woodhouse@intel.com>
<David.Woodhouse@intel.com>
+David Woodhouse <dwmw2@infradead.org>
<dwmw2@shinybook.infradead.org>
+David Woodhouse <dwmw2@infradead.org>
<dwmw2@tylersburg.infradead.org>
+David Woodhouse <dwmw2@infradead.org>
<dwmw2@bombadil.infradead.org>
+David Woodhouse <dwmw2@infradead.org>                   <dwmw2@org.rmk.(none)>
+Dean Gaudet <dean@arctic.org>
+Deepak Saxena <dsaxena@linaro.org>
<dsaxena@net.rmk.(none)>
+Denis Barrow <d.barrow@option.com>                      <D.Barrow@option.com>
+Denis Barrow <d.barrow@option.com>                      <D.Barow@option.com>
+Denis Carikli <GNUtoo@no-log.org>
+Denis Cheng <crquan@gmail.com>
+Denis Kirjanov <dkirjanov@kernel.org>
<dkirjanov@hera.kernel.org>
+Denis Lunev <den@openvz.org>
+Denis Lunev <den@sw.ru>
+Denis Lunev <den@parallels.com>
+Denis Monterrat <denis.monterrat@sagem.com>
+Denis Vlasenko <vda.linux@gmail.com>
<vda.linux@googlemail.com>
+Denis Sadykov <denis.m.sadykov@intel.com>
+Dennis Jansen <dennis.jansen@web.de>                    <Dennis.Jansen@web.de>
+Dennis Jansen <d.g.jansen@gmail.com>
<d.g.jansen@googlemail.com>
+Dennis Kügler <dennis.kuegler@gmx.de>
+Denys Fedoryshchenko <denys@visp.net.lb>
+Derek Kelly <user.vdr@gmail.com>
+Devendra Naga <devendra.aaru@gmail.com>
+Devin Pohly <djpohly@gmail.com>
+Dhananjay Phadke <dhananjay.phadke@qlogic.com>          <dhananjay@qlogic.com>
+Dhananjay Phadke <dhananjay@netxen.com>
+Dhananjay Phadke <dhananjay.phadke@gmail.com>
+Diana Craciun <diana.craciun@freescale.com>
<Diana.Craciun@freescale.com>
+Diego Calleja <diegocg@gmail.com>
+Diego Iglesias <diegohi@gmail.com>
+Diego Marfil <diegomarfil@gmail.com>
+Diego Petteno <flameeyes@gmail.com>
+Ding Dinghua <dingdinghua@nrchpc.ac.cn>
+Ding Dinghua <dingdinghua85@gmail.com>
+Dirk Behme <dirk.behme@gmail.com>
<dirk.behme_at_gmail.com>
+Dirk Behme <dirk.behme@gmail.com>
<dirk.behme@googlemail.com>
+Dirk De Schepper <ddeschepper@nvtl.com>
+Dirk Opfer <dirk@opfer-online.de>                       <Dirk@Opfer-Online.de>
+Dmitri Vorobiev <dmitri.vorobiev@movial.com>
<dmitri.vorobiev@movial.fi>
+Dmitry Belimov <d.belimov@gmail.com>
 Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
+Dmitry Kozlov <xeb@mail.ru>
+Dmitry Levin <ldv@altlinux.org>
+Dmitry Monakhov <dmonakhov@openvz.org>
+Dmitry Pervushin <dpervushin@embeddedalley.com>
+Dmitry Pervushin <dpervushin@ru.mvista.com>
+Dmitry Pervushin <dimka@nomadgs.com>
+Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
+Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
<Dmitry.Tarnyagin@stericsson.com>
+Dmitry Torokhov <dtor@mail.ru>                          <dtor at mail.ru>
 Domen Puncer <domen@coderock.org>
 Douglas Gilbert <dougg@torque.net>
-Ed L. Cashin <ecashin@coraid.com>
+Domen Puncer <domen@coderock.org>                       <dome@coderock.org>
+Dominik Geyer <dominik.geyer@gmx.de>
+Donald Dugger <donald.d.dugger@intel.com>
+Donald Fry <donald.h.fry@intel.com>
+Don Prince <dhprince.devel@yahoo.co.uk>
<dhprince-devel@yahoo.co.uk>
+Dotan Barak <dotanb@mellanox.co.il>
<dotanb@dev.mellanox.co.il>
+Douglas Schilling Landgraf <dougsland@gmail.com>
+Doug Thompson <dougthompson@xmission.com>               <norsk5@xmission.com>
+Doug Thompson <dougthompson@xmission.com>
<dougthompson@xmission.h>
+Duncan Sands <duncan.sands@free.fr>                     <baldrick@free.fr>
+Duncan Sands <duncan.sands@math.u-psud.fr>
<duncan.sands@math.u\-psud.fr>
+Dwaine Garden <dwainegarden@rogers.com>
+Dwaine Garden <dwainegarden@rogers.com>
<DwaineGarden@rogers.com>
+Dwayne Grant Mcconnell <decimal@us.ibm.com>
+Dylan Semler <dylan.semler@gmail.com>
+
+### E #####
+Ed Cashin <ecashin@coraid.com>
+Eddie Dost <ecd@brainaid.de>
+Eddie Wai <eddie.wai@broadcom.com>                      <waie@broadcom.com>
+Eddy Jansson <eddy@klopper.net>
+Edgar Hucek <gimli@dark-green.com>
+Edgar Iglesias <edgar.iglesias@petalogix.com>
+Edgar Iglesias <edgar@axis.com>
+Edgar Iglesias <edgar@axis.com>
<edgar.iglesias@axis.com>
+Edgar Iglesias <edgar.iglesias@gmail.com>
+Ed Lin <ed.lin@promise.com>
+Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>
+Eduardo Habkost <ehabkost@redhat.com>
+Eduardo Habkost <ehabkost@redhat.com>
<ehabkost@Rawhide-64.localdomain>
+Edward Goggin <egoggin@emc.com>
+Edward Shishkin <edward.shishkin@gmail.com>
+Edward Yang <ezyang@ksplice.com>
+Ed Wildgoose <git@wildgooses.com>                       <kernel@wildgooses.com>
+Edwin Rong <edwin_rong@realsil.com.cn>
+Edwin Török <edwintorok@gmail.com>
+Edwin Zhai <edwin.zhai@intel.com>
+Eiichiro Oiwa <eiichiro.oiwa.nm@hitachi.com>
+Eli Cohen <eli@mellanox.co.il>                          <eli@mellanox.com>
+Eli Cohen <eli@mellanox.co.il>
<eli@dev.mellanox.co.il>
+Eli Cohen <eli@mellanox.co.il>                          <eli at mellanox.co.il>
+Emmanuel Grumbach <emmanuel.grumbach@intel.com>
+Emilio Cota <cota@braap.org>
+Emil Medve <emilian.medve@freescale.com>
<Emilian.Medve@Freescale.com>
+Emil Medve <emilian.medve@freescale.com>
<Emilian.Medve@freescale.com>
+Enric Balletbò i Serra <eballetbo@iseebcn.com>
+Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
<enrico.scholz@de.rmk.(none)>
+Erez Zadok <ezk@cs.sunysb.edu>                          <ezk@fsl.cs.sunysb.edu>
+Eric Bénard <eric@eukrea.com>
+Eric Bénard <eric@eukrea.com>                           <ebenard@eukrea.com>
+Eric Bénard <ebenard@free.fr>
+Eric Biederman <ebiederm@xmission.com>
+Eric Biederman <ebiederm@aristanetworks.com>
+Eric Biederman <ebiederm@aristanetworks.com>
<ebiederm@maxwell.aristanetworks.com>
+Eric Biederman <ebiederm@xmission.com>
<ebiderman@xmission.com>
+Eric Biederman <ebiederm@xmission.com>
<ebiederman@xmission.com>
+Eric Biederman <eric@conroxe.ebiederm.org>
+Eric Biederman <ebiederman@lnxi.com>
+Erich Hoover <ehoover@mines.edu>
+Eric Lammerts <eric@lammerts.org>
<linux-arm@lists.lammerts.org>
+Eric Lammerts <eric@lammerts.org>
<alsa-devel@lists.lammerts.org>
+Eric Lescouet <eric.lescouet@virtuallogix.com>
<Eric.Lescouet@virtuallogix.com>
+Eric Lescouet <eric.lescouet@virtuallogix.com>
<lescouet@virtuallogix.com>
+Eric Miao <eric.miao@marvell.com>
+Eric Miao <eric.miao@marvell.com>
<ycmiao@ycmiao-ubuntu.internal.example.org>
+Eric Miao <eric.miao@marvell.com>
<ycmiao@ycmiao-hp520.(none)>
+Eric Miao <eric.y.miao@gmail.com>
+Eric Mudama <edmudama@gmail.com>
+Eric Munson <emunson@mgebm.net>
+Eric Munson <ebmunson@us.ibm.com>
+Eric Moore <eric.moore@lsi.com>                         <eric.moore@lsil.com>
+Eric Moore <eric.moore@lsi.com>                         <Eric.Moore@lsil.com>
+Eric Paris <eparis@redhat.com>                          <eparis@redhat>
+Eric Piel <eric.piel@tremplin-utc.net>
+Eric Piel <eric.piel@tremplin-utc.net>
<Eric.Piel@tremplin-utc.net>
+Eric Piel <e.a.b.piel@tudelft.nl>                       <E.A.B.Piel@tudelft.nl>
+Eric Sandeen <sandeen@redhat.com>
+Eric Sandeen <sandeen@redhat.com>                       <esandeen@redhat.com>
+Eric Sesterhenn <snakebyte@gmx.de>
+Eric Sesterhenn <snakebyte@gmx.de>
<[mailto:snakebyte@gmx.de]>
+Eric Wollesen <ericw@xmtp.net>
+Eric Van Hensbergen <ericvh@arly004.austin.ibm.com>
<ericvh@ericvh-desktop.austin.ibm.com>
+Eric Van Hensbergen <ericvh@arly004.austin.ibm.com>
<ericvh@ericvh-laptop.austin.ibm.com>
+Eric Van Hensbergen <ericvh@arly004.austin.ibm.com>
<ericvh@strongmad.austin.ibm.com>
+Eric Van Hensbergen <ericvh@arly004.austin.ibm.com>     <ericvh@opteron.(none)>
+Eric Van Hensbergen <ericvh@arly004.austin.ibm.com>
<ericvh@ericvh-laptop.(none)>
+Eric Van Hensbergen <ericvh@arly004.austin.ibm.com>
<ericvh@opteron.homeip.net>
+Eric Van Hensbergen <ericvh@arly004.austin.ibm.com>
<ericvh@opteron.9grid.us>
+Eric Van Hensbergen <ericvh@arly004.austin.ibm.com>
<ericvh@ericvh-desktop.(none)>
+Eric Van Hensbergen <ericvh@arly004.austin.ibm.com>
<ericvh@vTrogdor.(none)>
+Erik Andrén <erik.andren@gmail.com>
+Erik Beiser <erikb@bu.edu>
+Erik Bosman <ejbosman@cs.vu.nl>                         <ebn310@few.vu.nl>
+Erik Staab <ejs@insightbb.com>
+Erik Waling <erik.waling@konftel.com>
<erik.waling@konftel.se>
+Erling Jacobsen <linuxcub@email.dk>
+Ernesto Ramos <ernesto@ti.com>
<ernesto@ernesto-desktop.(none)>
+Erwan Le Disez <eledisez@grounation.org>
+Ester Kummer <ester.kummer@intel.com>
+Ester Kummer <ester.kummer@intel.com>
<stkumer@localhost.localdomain>
+Etienne Basset <etienne.basset@numericable.fr>
+Eugene Shatokhin <dame_eugene@mail.ru>
+Eugene Teo <eugeneteo@kernel.org>                       <eugeneteo@kernel.sg>
+Eugeny Mints <emints@ru.mvista.com>
+Eun-Chul Kim <chulspro.kim@samsung.com>
+Evgeniy Dushistov <dushistov@mail.ru>
 Evgeniy Polyakov <johnpol@2ka.mipt.ru>
-Felipe W Damasio <felipewd@terra.com.br>
-Felix Kuhling <fxkuehl@gmx.de>
-Felix Moeller <felix@derklecks.de>
+
+### F #####
+Fabien Cosse <fabien.cosse@wanadoo.fr>
+Fabio Checconi <fabio@gandalf.sssup.it>                 <fabio@gandalf.sssup.i>
+Fabio Di Nitto <fdinitto@redhat.com>
+Fabio Di Nitto <fabbione@fabbione.net>
+Fabio Di Nitto <fabbione@ubuntu.com>
+Fabrice Aeschbacher <fabrice.aeschbacher@siemens.com>
<Fabrice.Aeschbacher@siemens.com>
+Felipe Balbi <me@felipebalbi.com>                       <me@felipe.balbi.com>
+Felipe Damasio <felipewd@terra.com.br>
+Felix Kuehling <fxkuehl@gmx.de>
+Felix Kuehling <felix.kuehling@amd.com>
<Felix.Kuehling@amd.com>
+Felix Möller <felix@derklecks.de>
+Fengguang Wu <fengguang.wu@intel.com>
+Fengguang Wu <fengguang.wu@intel.com>                   <wfg@linux.intel.com>
+Fenghua Yu <fenghua.yu@intel.com>
<[fenghua.yu@intel.com]>
+Feng Liu <eric.e.liu@intel.com>
+Feng Kan <fkan@amcc.com>
+Fengzhe Zhang <fengzhe.zhang@intel.com>
+Ferenc Havasi <havasi@inf.u-szeged.hu>                  <haf@kpax.(none)>
+Ferenc Wagner <wferi@niif.hu>
+Fernando Guzman Lugo <fernando.lugo@ti.com>
+Fernando Guzman Lugo <fernando.lugo@ti.com>             <x0095840@ti.com>
+Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp>      <fernando@oss.ntt.co>
+Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp>
+Fernando Luis Vázquez Cao <fernando@intellilink.co.jp>
+Fernando Pereda <ferdy@gentoo.org>
+Figo Zhang <figo1802@gmail.com>
+Figo Zhang <figo.zhang@kolorific.com>
+Figo Zhang <zhangtianfei@leadcoretech.com>
 Filipe Lautert <filipe@icewall.org>
-Franck Bui-Huu <vagabon.xyz@gmail.com>
+Flavio Leitner <fbl@redhat.com>                         <fleitner@redhat.com>
+Florent Audebert <florent.audebert@anevia.com>
+Florian Mickler <florian@mickler.org>
+Forrest Zhao <forrest.zhao@intel.com>
+Foukas Xenofon <foukas.xenofon@gmail.com>
+Francesco Gringoli <francesco.gringoli@ing.unibs.it>
+Francesco Virlinzi <francesco.virlinzi@st.com>
+François Cami <francois.cami@free.fr>
+François Romieu <romieu@fr.zoreil.com>
+François Romieu <romieu@fr.zoreil.com>
<romieu@crap.fr.zoreil.com>
+François Romieu <romieu@fr.zoreil.com>
<romieu@nail.test.fr.zoreil.com>
+François Romieu <romieu@fr.zoreil.com>
<romieu@electric-eye.fr.zoreil.com>
+Franck Bui-Huu <fbuihuu@gmail.com>
+Franck Bui-Huu <fbuihuu@gmail.com>                      <vagabon.xyz@gmail.com>
+Franck Bui-Huu <fbuihuu@gmail.com>                      <fbh.work@gmail.com>
+Frank Blaschka <frank.blaschka@de.ibm.com>
+Frank Blaschka <frank.blaschka@de.ibm.com>
<Frank.Blaschka@de.ibm.com>
+Frank Filz <ffilzlnx@us.ibm.com>                        <ffilz@us.ibm.com>
+Frank Kingswood <frank@kingswood-consulting.co.uk>
+Frank Pavlic <fpavlic@de.ibm.com>                       <pavlic@de.ibm.com>
 Frank Zago <fzago@systemfabricworks.com>
-Greg Kroah-Hartman <greg@echidna.(none)>
+Frans Meulenbroeks <fransmeulenbroeks@gmail.com>
+Frédéric Briére <fbriere@fbriere.net>
+Frederic Cand <frederic.cand@anevia.com>
+Frédéric Leroy <fredo@starox.org>
+Frédéric Lambert <frdrc66@gmail.com>
+Frédéric Riss <frederic.riss@gmail.com>
+Frédéric Rodo <f.rodo@til-technologies.fr>
+Frédéric Weisbecker <fweisbec@gmail.com>
+Fred Templin <fred.l.templin@boeing.com>
<Fred.L.Templin@boeing.com>
+
+### G #####
+Gábor Egry <gaboregry@t-online.hu>
+Gábor Egry <gaboregry@t-online.hu>
<gaboregry1@t-online.hu>
+Gabriel Craciunescu <nix.or.die@googlemail.com>
+Gabriel Devenyi <ace@staticwave.ca>
+Gabriele Trombetti <g.trombetti.lkrnl1213@logicschema.com>
+Gao Feng <gaofeng@cn.fujitsu.com>
+Gao Feng <omarapazanadi@gmail.com>
+Garrett Damore <garrett_damore@tadpole.com>
+Gary Smith <gary.w.smith@primeexalia.com>
+Gautham Shenoy <ego@in.ibm.com>
+Gavin Zhu <gavin.kx@qq.com>
+Geert Uytterhoeven <geert.uytterhoeven@eu.sony.com>
<Geert.Uytterhoeven@eu.sony.com>
+Geert Uytterhoeven <geert.uytterhoeven@eu.sony.com>
<Geert.Uytterhoeven@sonycom.com>
+Gene Sally <gene.sally@timesys.com>
<Gene.Sally@timesys.com>
+Gen Fukatsu <fukatsu.gen@jp.panasonic.com>
+Gennady Sharapov <gennady.v.sharapov@intel.com>
<Gennady.V.Sharapov@intel.com>
+Geoffrey Levand <geoffrey.levand@am.sony.com>
+George Davis <gdavis@mvista.com>
+George Davis <gdavis@mvista.com>
<davis_g@com.rmk.(none)>
+George Davis <gdavis@mvista.com>                        <davis_g@mvista.com>
+George Wilson <ltcgcw@us.ibm.com>
+Gerald Schaefer <gerald.schaefer@de.ibm.com>            <geraldsc@de.ibm.com>
+Gerd Hoffmann <kraxel@bytesex.org>
+Gerd Hoffmann <kraxel@suse.de>
+Gernot Hillier <gernot.hillier@siemens.com>
+Geunsik Lim <leemgs1@gmail.com>
+Gilbert Wu <Gilbert_Wu@adaptec.com>
+Girish Shilamkar <girish.shivananjappa@linaro.org>
+Giuseppe Cavallaro <peppe.cavallaro@st.com>
+Giuseppe Gorgoglione <giuseppe.gorgoglione@st.com>
+Glauber de Oliveira Costa <gcosta@redhat.com>           <glommer@redhat.com>
+Glauber de Oliveira Costa <gcosta@redhat.com>           <gcosta@redhat.com>
+Glauber de Oliveira Costa <gocosta@br.ibm.com>          <glommer@br.ibm.com>
+Glauber de Oliveira Costa <glommer@parallels.com>
+Govindraj Raja <govindraj.raja@ti.com>
+Graham Howe <gman.1352@googlemail.com>
+Grant Likely <grant.likely@secretlab.ca>
+Grant Coady <gcoady.lk@gmail.com>                       <gcoady@gmail.com>
+Grant Grundler <iod00d@hp.com>
<grundler@gsyprf11.external.hp.com>
+Greg Banks <gnb@sgi.com>                                <gnb@melbourne.sgi.com>
+Greg Dietsche <gregory.dietsche@cuw.edu>
<Gregory.Dietsche@cuw.edu>
+Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 Greg Kroah-Hartman <gregkh@suse.de>
+Greg Kroah-Hartman <gregkh@suse.de>                     <greg@echidna.(none)>
 Greg Kroah-Hartman <greg@kroah.com>
-Henk Vergonet <Henk.Vergonet@gmail.com>
+Greg Kroah-Hartman <greg@kroah.com>                     <gregkh@kvm.kroah.org>
+Greg Kroah-Hartman <greg@kroah.com>                     <greg@press.kroah.org>
+Greg Kroah-Hartman <greg@kroah.com>                     <greg@press.(none)>
+Gregor Kowski <gregor.kowski@gmail.com>
+Gregory Clement <gregory.clement@free-electrons.com>
+Gregory Clement <gclement00@gmail.com>
+Gregory Frost <frosts1@hotkey.net.au>
+Gregory Graeme <gg@slimlogic.co.uk>
+Gregory Graeme <graeme@openmoko.com>                    <graeme@openmoko.org>
+Grégory Lardière <spmf2004-m560x@yahoo.fr>
+Gregory Rose <gregory.v.rose@intel.com>
+Greg Ungerer <gerg@uclinux.org>                         <gerg@goober.(none)>
+Greg Wettstein <greg@enjellic.com>
+Grzegorz Chwesewicz <grzegorz.chwesewicz@chilan.com>
+Guan Xuetao <gxt@mprc.pku.edu.cn>
+Guennadi Liakhovetski <g.liakhovetski@gmx.de>           <lyakh@axis700.grange>
+Guennadi Liakhovetski <g.liakhovetski@gmx.de>
<lyakh@extensa5220.grange>
+Guido Günther <agx@sigxcpu.org>
+Guilherme Schroeder <guilherme.m.schroeder@gmail.com>
+Guillaume Gardet <guillaume.gardet@free.fr>
+Guillaume Gourat <guillaume.gourat@nexvision.fr>
+Guillaume Lecerf <glecerf@gmail.com>
+Guillaume Lecerf <glecerf@gmail.com>                    <foxcore@gmail.com>
+Guillaume Thouvenin <guillaume.thouvenin@bull.net>
<guillaume.thouvenin@ext.bull.net>
+Gunnar Larisch <gunnar.larisch@gmx.de>                  <Gunnar.Larisch@gmx.de>
+Gustavo Padovan <padovan@profusion.mobi>
+Gustavo Padovan <gustavo@las.ic.unicamp.br>
+Gustavo Padovan <gustavo@padovan.org>
+Gwendal Grignou <ggrignou@brocade.com>                  <ggrignou@Brocade.COM>
+
+### H #####
+Haihao Xiang <haihao.xiang@intel.com>
+Hannes Hering <hering2@de.ibm.com>
<hannes.hering@linux.vnet.ibm.com>
+Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
<hcegtvedt@norway.atmel.com>
+Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com> <hcegtvedt@atmel.com>
+Hans de Goede <hdegoede@redhat.com>                     <hdgoede@redhat.com>
+Hans-Joachim Picht <hans@linux.vnet.ibm.com>            <hans@de.ibm.com>
+Hansjörg Lipp <hjlipp@web.de>
+Hans-Jürgen Tappe <hjt@sysgo.com>
+Hans Koch <hjk@hansjkoch.de>
+Hans Koch <hjk@linutronix.de>
+Hans Koch <koch@hjk-az.de>
+Hans Kroll <ulli.kroll@gmail.com>
<ulli.kroll@googlemail.com>
+Hans Niedermann <hun@n-dimensional.de>
+Harald Krapfenbauer <harald.krapfenbauer@bluetechnix.at>
<Harald.Krapfenbauer@bluetechnix.at>
+Harald Welte <haraldwelte@viatech.com>
<HaraldWelte@viatech.com>
+Haren Myneni <haren@us.ibm.com>                         <hbabu@us.ibm.com>
+Hari Kanigeri <h-kanigeri2@ti.com>
+Harry Wei <harryxiyou@gmail.com>
<jiaweiwei.xiyou@gmail.com>
+Hartley Sweeten <hartleys@visionengravers.com>
+Hartley Sweeten <hartleys@visionengravers.com>
<hsweeten@visionengravers.com>
+Hartmut Birr <e9hack@gmail.com>                         <e9hack@googlemail.com>
+Hartmut Hackmann <hartmut.hackmann@t-online.de>
+Hartmut Hackmann <hartmut.hackmann@t-online.de>
<hartmut.hackmann@t.online.de>
+Hartmut Hackmann <hartmut.hackmann@t-online.de>
<hartmut.hackmann@t\-online.de>
+Hartmut Hackmann <hartmut.hackmann@t-online.de>
<hartmut.hackmann@t\\-online.de>
+Håvard Skinnemoen <hskinnemoen@google.com>
+Håvard Skinnemoen <hskinnemoen@atmel.com>
+Håvard Skinnemoen <hskinnemoen@atmel.com>
<haavard.skinnemoen@atmel.com>
+Hayes Wang <hayeswang@realtek.com>
+Heikki Krogerus <heikki.krogerus@nokia.com>
<ext-heikki.krogerus@nokia.com>
+Heiko Carstens <h.carstens@de.ibm.com>
<heiko.carstens@de.ibm.com>
+Heiko Schick <schihei@de.ibm.com>
+Heiko Schick <schihei@de.ibm.com>                    <schickhj.ibm.com>
+Heiko Schick <schihei@de.ibm.com>                    <schihei@de.ibm.com>
+Heiko Stübner <heiko@sntech.de>
+Heinz Mauelshagen <heinzm@redhat.com>                   <hjm@redhat.com>
+Heinz Mauelshagen <heinzm@redhat.com>
<mauelshagen@redhat.com>
+Helmut Schaa <helmut.schaa@gmx.de>                      <Helmut.Schaa@gmx.de>
+Helmut Schaa <helmut.schaa@gmail.com>
<helmut.schaa@googlemail.com>
+Hema Kalliguddi <hemahk@ti.com>
+Henk Vergonet <henk.vergonet@gmail.com>
<Henk.Vergonet@gmail.com>
 Henrik Kretzschmar <henne@nachtwindheim.de>
+Henrik Kretzschmar <henne@nachtwindheim.de>             <henne@nachtwidheim.de>
+Henrik Kretzschmar <henne@nachtwindheim.de>
<henrik@nachtwindheim.de>
+Henrik Kurelid <henrik@kurelid.se>                      <henke@kurelid.se>
+Henrik Rydberg <rydberg@euromail.se>                    <rydberg@thabit.(none)>
+Henrik Sjoberg <hsjo@epact.se>                          <henke@epact.se>
+Henry Chang <henry.cy.chang@gmail.com>
+Henry Chang <henry_c_chang@tcloudcomputing.com>
+Henry Su <henry.su.ati@gmail.com>
 Herbert Xu <herbert@gondor.apana.org.au>
-Jacob Shin <Jacob.Shin@amd.com>
-James Bottomley <jejb@mulgrave.(none)>
-James Bottomley <jejb@titanic.il.steeleye.com>
-James E Wilson <wilson@specifix.com>
-James Ketrenos <jketreno@io.(none)>
+Hermann Kneissel <herkne@gmx.de>
<hermann.kneissel@gmx.net>
+Hermann Kneissel <herkne@gmx.de>
<hermann.kneissel@gmx.de>
+Hermann Pitton <hermann-pitton@arcor.de>
+Herton Krzesinski <herton@mandriva.com.br>
+Herton Krzesinski <herton@mandriva.com.br>      <herton@mandriva.com>
+Herton Krzesinski <herton.krzesinski@canonical.com>
+HeungJun Kim <riverful.kim@samsung.com>
+Hideaki Yoshifuji <yoshfuji@linux-ipv6.org>
+Hideaki Yoshifuji <yoshfuji@linux-ipv6.org>
<yosufuji@linux-ipv6.org>
+Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
+Hideo Aoki <haoki@redhat.com>
+Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
<[seto.hidetoshi@jp.fujitsu.com]>
+Himanshu Chauhan <himanshu@symmetricore.com>
+Himanshu Chauhan <himanshu@symmetricore.com>
<Himanshu@symmetricore.com>
+Hiroaki Shimoda <shimoda.hiroaki@gmail.com>
+Hiroaki Taruisi <taruishi.hiroak@jp.fujitsu.com>
+Hirofumi Ogawa <hirofumi@mail.parknet.co.jp>
+Hiroki Nishimoto <nishimoto.hiroki@renesas.com>
+Hiromu Yagura <hiromu1996@gmail.com>
+Hiroshi Doyu <hdoyu@nvidia.com>
+Hiroshi Doyu <hiroshi.doyu@nokia.com>
<Hiroshi.DOYU@nokia.com>
+Hiroyuki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>
+Hiroyuki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>
<kamezawa.hioryu@jp.fujitsu.com>
+Hiroyuki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>
<kamzawa.hiroyu@jp.fujitsu.com>
+Hiroyuki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>
<kamezawa@bluextal.(none)>
+Hiroyuki Yamamori <h-yamamo@db3.so-net.ne.jp>
+Hitoshi Nakamori <hitoshi.nakamori@gmail.com>
+Hisanobu Tomari <posco.grubb@gmail.com>
+H. J. Lu <hjl.tools@gmail.com>
+Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>           <hnguyen@de.ibm.com>
+Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>           <hnguyen at de.ibm.com>
+Holger Freyther <holger@freyther.de>
+Holger Freyther <zecke@selfish.org>
+Holger Schurig <holgerschurig@gmail.com>
<holgerschurig@googlemail.com>
+Holger Schurig <h.schurig@mn-solutions.de>
<hs4233@mail.mn-solutions.de>
+Holger Smolinski <smolinski@de.ibm.com>
<holger.smolinski@de.ibm.com>
+Holger Smolinski <smolinski@de.ibm.com>
<Holger.Smolinski@de.ibm.com>
+Hong-Xing Zhu <richard.zhu@linaro.org>
+Hong-Xing Zhu <hong-xing.zhu@freescale.com>
<Hong-Xing.Zhu@freescale.com>
+Horst von Brand <vonbrand@inf.utfsm.cl>
+Howard Chu <hyc@symas.com>
+Huacai Chen <huacai.chen@intel.com>
+Huajun Li <huajun.li.lee@gmail.com>
+Hui Xiao <hui.xiao@linux.intel.com>
+Hyok Choi <hyok.choi@samsung.com>
+
+### I #####
+Ian Campbell <ian.campbell@xensource.com>
<Ian.Campbell@XenSource.com>
+Ian Campbell <ian.campbell@xensource.com>
<Ian.Campbell@xensource.com>
+Ian Campbell <ian.campbell@citrix.com>
<Ian.Campbell@citrix.com>
+Ian Campbell <ian.campbell@citrix.com>
<Ian.Campbell@eu.citrix.com>
+Ian Morgan <penguin.wrangler@gmail.com>
+Ian Morgan <imorgan@webcon.ca>
+Ian Munsie <imunsie@au.ibm.com>                         <imunsie@au1.ibm.com>
+Ian Nelson <nelsonian@comcast.net>
+Igor Mammedov <niallan@gmail.com>                       <niallain@gmail.com>
+Igor Maravić <igorm@etf.rs>
+Igor Liplianin <liplianin@me.by>
+Igor Liplianin <liplianin@tut.by>
+Igor Liplianin <liplianin@netup.ru>
+Ilia Kolomisnky <ilia.kolominsky@gmail.com>             <mail4ilia@gmail.com>
+Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
+Ilya Matvejchikov <matvejchikov@gmail.com>
+Ilya Volynets-Evenbakh <ilya@total-knowledge.com>
+Iñaky Pérez-González <inaky.perez-gonzalez@intel.com>
+Iñaky Pérez-González <inaky.perez-gonzalez@intel.com>   <inaky@linux.intel.com>
+Ingo Molnar <mingo@elte.hu>                             <mingo@elte.he>
+Ingo Molnar <mingo@kernel.org>                          <mingo@hera.kernel.org>
+Ingo Molnar <mingo@kernel.org>                          <mingo@europe.(none)>
+Inki Dae <inki.dae@samsung.com>
+Inki Dae <daeinki@gmail.com>
+Ira Snyder <iws@ovro.caltech.edu>
+Ira Snyder <kernel@irasnyder.com>
+Istvan Varga <istvan_v@mailbox.hu>
+Ivan Skytte Jørgensen <isj-sctp@i1.dk>
+Ivan Zlatev <contact@i-nz.net>
+Ivo van Doorn <ivdoorn@gmail.com>                       <IvDoorn@gmail.com>
+Izik Eidus <izike@qumranet.com>                         <avi@qumranet.com>
+Izik Eidus <izike@qumranet.com>
<izike@localhost.localdomain>
+
+### J #####
+Jack Morgenstein <jackm@mellanox.co.il>
<jackm@dev.mellanox.co.il>
+Jack Morgenstein <jackm@mellanox.co.il>                 <jackm@mellanox.com>
+Jack Vogel <jfv@bluesong.net>
+Jack Wang <jack_wang@usish.com>
+Jacob Pan <jacob.jun.pan@linux.intel.com>
+Jacob Pan <jacob.jun.pan@linux.intel.com>
<jacob.jun.pan@intel.com>
+Jacob Shin <jacob.shin@amd.com>                         <Jacob.Shin@amd.com>
+Jae-hyeon Park <jhpark@tuhep.phys.tohoku.ac.jp>
<hpark@tuhep.phys.tohoku.ac.jp>
+Jakub Kiciński <kubakici@wp.pl>
+Jakub Jozwicki <jakub007@go2.pl>
+J.A. Magallón <jamagallon@ono.com>
+J.A. Magallón <jamagallon@able.es>
+Jamal Hadi Salim <hadi@cyberus.ca>
+James A. Webb <jamesawebb@gmail.com>
+James Bottomley <jbottomley@parallels.com>
<JBottomley@Parallels.com>
+James Bottomley <james.bottomley@steeleye.com>
<James.Bottomley@steeleye.com>
+James Bottomley <james.bottomley@steeleye.com>
<James.Bottomley@SteelEye.com>
+James Bottomley <james.bottomley@hansenpartnership.com>
<James.Bottomley@HansenPartnership.com>
+James Bottomley <james.bottomley@suse.de>
<James.Bottomley@suse.de>
+James Bottomley <james.bottomley@steeleye.com>
<[mailto:James.Bottomley@SteelEye.com]>
+James Bottomley <james.bottomley@steeleye.com>
<jejb@mulgrave.il.steeleye.com>
+James Bottomley <james.bottomley@steeleye.com>          <jejb@mulgrave.(none)>
+James Bottomley <james.bottomley@steeleye.com>
<jejb@mulgrave.localdomain>
+James Bottomley <james.bottomley@steeleye.com>
<jejb@titanic.il.steeleye.com>
+James Bottomley <james.bottomley@steeleye.com>          <jejb@titanic>
+James Bottomley <james.bottomley@steeleye.com>          <jejb@titanic.(none)>
+James Bottomley <james.bottomley@steeleye.com>
<jejb@sparkweed.localdomain>
+James Bottomley <james.bottomley@steeleye.com>
<jejb@hobholes.localdomain>
+James Freyensee <james_p_freyensee@linux.intel.com>
+James Georgas <jgeorgas@rogers.com>
+James Ketrenos <jketreno@linux.intel.com>               <jketreno@io.(none)>
+James Morris <jmorris@namei.org>                        <jmorris@halo.namei>
+James Morris <jmorris@namei.org>                        <jmorris@sdv.(none)>
+James Morris <jmorris@namei.org>
<jmorris@macbook.(none)>
+James Morris <jmorris@namei.org>
<jmorris@macbook.localdomain>
+James Morris <jmorris@namei.org>
<jmorris@localhost.localdomain>
+James Klaas <jklaas@appalachian.dyndns.org>
+James Leddy <james.leddy@canonical.com>
+James Lewis <jklewis@us.ibm.com>
+James McLaren <mclaren@tulane.edu>
+James R. Webb <jrwebb@qwest.net>
+James Simmons <jsimmons@infradead.org>
<jsimmons@www.infradead.org>
+James Smart <james.smart@emulex.com>
<James.Smart@Emulex.Com>
+James Treacy <treacy@debian.org>
+James Wilson <wilson@specifix.com>
+James Yang <james.yang@freescale.com>
<James.Yang@freescale.com>
+Jamie Lentin <jm@lentin.co.uk>                          <jamie@lentin.co.uk>
+Janak Desai <janak@us.ibm.com>
+Jan Altenberg <jan@linutronix.de>
<jan.altenberg@linutronix.de>
+Jan-Bernd Themann <ossthema@de.ibm.com>                 <themann@de.ibm.com>
+Jan Beulich <jbeulich@suse.com>                         <JBeulich@suse.com>
+Jan Beulich <jbeulich@novell.com>                       <JBeulich@novell.com>
+Jan Blunck <jblunck@suse.de>
+Jan Glauber <jang@linux.vnet.ibm.com>
<jan.glauber@de.ibm.com>
+Jan Glauber <jang@linux.vnet.ibm.com>                   <jang@de.ibm.com>
+Jan Kara <jack@suse.cz>
+Jan Kara <jack@suse.cz>                                 <jack@ghost.suse.cz>
+Jan Kasprzak <kas@fi.muni.cz>
+Jan Lübbe <jluebbe@debian.org>
+Jan Schönherr <schnhrr@cs.tu-berlin.de>
+Jan Sonnek <xsonnek@gmail.com>
+Janusz Dziedzic <janusz.dziedzic@tieto.com>
<Janusz.Dziedzic@tieto.com>
+Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>              <jkrzysz@tis.icnet.pl>
+Jarod Wilson <jarod@redhat.com>                         <jwilson@redhat.com>
+Jaroslav Kysela <perex@suse.cz>
+Jaroslav Kysela <perex@perex.cz>                        <perex@server.perex.cz>
+Jaroslav Kysela <perex@perex.cz>                        <perex@petra>
+Jaroslav Kysela <perex@perex.cz>                        <perex@tm8103>
+Jason Gaston <jason.d.gaston@intel.com>
+Jason Gaston <jason.d.gaston@intel.com>
<Jason.d.gaston@intel.com>
+Jason Jin <jason.jin@freescale.com>
<Jason.jin@freescale.com>
+Jason Lam <lzg@ema-tech.com>
+Jason McMullan <jason.mcmullan@timesys.com>
+Jaswinder Singh <jaswinder.singh@linaro.org>
+Jaswinder Singh <jaswinderlinux@gmail.com>
<jassisinghbrar@gmail.com>
+Jaswinder Singh <jaswinderlinux@gmail.com>
<jaswinderrajput@gmail.com>
+Jaswinder Singh <jaswinder@kernel.org>
<[jaswinder@kernel.org]>
+Javier Blanco de Torres <jblanco@neurowork.net>
+Javier Cardona <javier@cozybit.com>
+Javier Martin <javier.martin@vista-silicon.com>
+Javier Muñoz Mellid <jmunhoz@igalia.com>
+Jaya Kumar <jayakumar.lkml@gmail.com>
<jayakumar.ide@gmail.com>
+Jaya Kumar <jayakumar.lkml@gmail.com>
<jayakumar.alsa@gmail.com>
+Jaya Kumar <jayakumar.lkml@gmail.com>
<jayakumar.acpi@gmail.com>
+Jaya Kumar <jayakumar.lkml@gmail.com>
<jayakumar.arm@gmail.com>
+Jaya Kumar <jayakumar.lkml@gmail.com>
<jayakumar.video@gmail.com>
+Jay Estabrook <jay.estabrook@hp.com>                    <Jay.Estabrook@hp.com>
+Jay Lan <jlan@sgi.com>                                  <jlan@engr.sgi.com>
+Jayson King <dev@jaysonking.com>
+Jay Sternberg <jay.e.sternberg@intel.com>
<jay.e.sternberg@linux.intel.com>
+J. Bruce Fields <bfields@citi.umich.edu>
<bfields@snoopy.citi.umich.edu>
+J. Bruce Fields <bfields@fieldses.org>
<bfields@puzzle.fieldses.org>
+J. Bruce Fields <bfields@fieldses.org>
<bfields@pad.home.fieldses.org>
+J. Bruce Fields <bfields@fieldses.org>
<bfields@pig.fieldses.org>
+Jean-Christophe Dubois <jcd@tribudubois.net>
+Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
+Jean Delvare <khali@linux-fr.org>                       <khali@linux\-fr.org>
+Jean Delvare <khali@linux-fr.org>                       <khali@arrakis.delvare>
+Jean Delvare <khali@linux-fr.org>
<khali@hyperion.delvare>
+Jean Delvare <khali@linux-fr.org>
<khali@mahadeva.delvare>
+Jean Delvare <khali@linux-fr.org>
<khali@endymion.delvare>
+Jean-François Moine <moinejf@free.fr>
+Jean-Luc Léger <jean-luc.leger@dspnet.fr.eu.org>
 Jean Tourrilhes <jt@hpl.hp.com>
 Jeff Garzik <jgarzik@pretzel.yyz.us>
+Jeff Garzik <jeff@garzik.org>
<jgarzik@localhost.localdomain>
+Jeff Kirsher <jeffrey.t.kirsher@intel.com>
<Jeffrey.t.kirsher@intel.com>
+Jeff Layton <jlayton@redhat.com>
+Jeffrey Chu <jeffchu@broadcom.com>
+Jeffrey Ohlstein <johlstei@codeaurora.org>
+Jeffrey Vandenbroucke <jeffrey@wirehead.be>
 Jens Axboe <axboe@suse.de>
-Jens Osterkamp <Jens.Osterkamp@de.ibm.com>
+Jens Axboe <axboe@kernel.dk>
<axboe@carl.home.kernel.dk>
+Jens Axboe <axboe@kernel.dk>                            <axboe@carl.(none)>
+Jens Axboe <axboe@kernel.dk>                            <axboe@carl>
+Jens Axboe <axboe@kernel.dk>
<axboe@nelson.home.kernel.dk>
+Jens Künzer <Jens.Kuenzer@fpga.homeip.net>
+Jens Nödler <noedler@web.de>
+Jens Osterkamp <jens@de.ibm.com>                        <osterkam@de.ibm.com>
+Jens Osterkamp <jens@de.ibm.com>
<Jens.Osterkamp@de.ibm.com>
+Jens Osterkamp <jens@de.ibm.com>
<jens.osterkamp@de.ibm.com>
+Jens Rottmann <jrottmann@lippertembedded.de>
<JRottmann@LiPPERTEmbedded.de>
+Jens Rottmann <jrottmann@lippertembedded.de>
<JRottmann@lippert-at.de>
+Jens Rottmann <jrottmann@lippertembedded.de>
<JRottmann@LiPPERT-AT.de>
+Jeremy Allison <jra@samba.com>                          <jra@samba.org>
+Jérémy Cochoy <jeremy.cochoy@gmail.com>
+Jérémy Lal <kapouer@melix.org>
+Jeroen Simonetti <jeroen@simonetti.nl>
+Jérôme Pouiller <jezz@sysmic.org>
+Jerry Chuang <jerry-chuang@realtek.com>                 <wlanfae@realtek.com>
+Jesper Dangaard Brouer <hawk@comx.dk>                   <jdb@comx.dk>
+Jesper Juhl <jesper.juhl@gmail.com>                     <Jesper.Juhl@Gmail.Com>
+Jesper Juhl <juhl@dif.dk>                               <juhl-lkml@dif.dk>
+Jesper Nilsson <jespern@axis.com>
<jesper.nilsson@axis.com>
+Jesper Nilsson <jespern@axis.com>
<Jesper.Nilsson@axis.com>
+Jesper Nilsson <jespern@axis.com>
<jespern@stork.se.axis.com>
+Jesse Barnes <jbarnes@virtuousgeek.org>                 <jbarnes at
virtuousgeek.org>
+Jesse Barnes <jbarnes@virtuousgeek.org>
<jbarnes@nietzche.virtuousgeek.org>
+Jesse Barnes <jbarnes@virtuousgeek.org>
<jbarnes@jbarnes-acer.localdomain>
+Jesse Barnes <jbarnes@virtuousgeek.org>
<jbarnes@jbarnes-g45.(none)>
+Jesse Barnes <jbarnes@virtuousgeek.org>
<jbarnes@jbarnes-t61.(none)>
+Jesse Barnes <jbarnes@virtuousgeek.org>
<jbarnes@jbarnes-x200.(none)>
+Jesse Barnes <jbarnes@virtuousgeek.org>                 <jbarnes@hobbes.(none)>
+Jesse Barnes <jbarnes@virtuousgeek.org>                 <jbarnes@hobbes.lan>
+Jesse Barnes <jbarnes@virtuousgeek.org>
<jbarnes@hobbes.virtuousgeek.org>
+Jesse Brandeburg <jesse.brandeburg@intel.com>
+Jessica Blank <j@twu.net>
+Jes Sorensen <jes.sorensen@redhat.com>
<Jes.Sorensen@redhat.com>
+Jett Zhou <jtzhou@marvell.com>
+Jian Gui <guij@cn.ibm.com>
+Jia Zhang <jia.zhang2008@gmail.com>
+Jiang Zhe <zhe.jiang@intel.com>
+Jianjun Kong <jianjun@zeuux.org>
+Jianjun Ye <joeyye@trident.com.cn>
+Jianwei Yang <jianwei.yang@intel.com>
+Jiaying Zhang <jiayingz@google.com>
<jiayingz@google.com (Jiaying Zhang)>
+Jidong Xiao <jidong.xiao@gmail.com>
+Jie Yang <jie.yang@atheros.com>
+Jie Yang <jie.yang@atheros.com>                         <Jie.Yang@atheros.com>
+Jim Keniston <jkenisto@us.ibm.com>
<jkenisto@linux.vnet.ibm.com>
+Jing Huang <huangj@brocade.com>                         <huangj@Brocade.com>
+Jinsong Liu <jinsong.liu@intel.com>
+Jing Zhang <zj.barak@gmail.com>
+Jiri Olsa <jolsa@redhat.com>
+Jiri Pinkava <jiri.pinkava@vscht.cz>                    <Jiri.Pinkava@vscht.cz>
+Jiro Sekiba <jir@unicus.jp>
+Joachim Foerster <joft@gmx.de>                          <JOFT@gmx.de>
+Joachim Foerster <joft@gmx.de>                          <mls.JOFT@gmx.de>
+Joakim Tjernlund <joakim.tjernlund@transmode.se>
<Joakim.Tjernlund@transmode.se>
+Joe Gunn <armadefuego@yahoo.com>
+Joe Kappus <joecool1029@gmail.com>
+Joel Becker <joel.becker@oracle.com>
<Joel.Becker@oracle.com>
+Joel Fernandes <joelagnel@ti.com>
+Joel Fowler <fowlerja@us.ibm.com>
+Joel Schopp <jschopp@us.ibm.com>
+Joel Schopp <jschopp@us.ibm.com>
<jschopp@austin.ibm.com>
+Joe Perches <joe@perches.com>
+Joe Thornber <ejt@redhat.com>                           <thornber@redhat.com>
+Johan Henriksson <jhn98032@gmail.com>
+Johannes Hölzl <johannes.hoelzl@gmx.de>
+Johannes Weiner <hannes@cmpxchg.org>                    <[hannes@cmpxchg.org]>
+Johannes Weiner <hannes@saeurebad.de>
<hannes-kernel@saeurebad.de>
+John Burr <jlburr@cadence.com>
+John Bohach <jzb@aexorsyst.com>
+John Cooper <john.cooper@redhat.com>
+John Fastabend <john.r.fastabend@intel.com>
+John Gruber <johnsgruber@gmail.com>
+John Gruber <johnsgruber@gmail.com>                     <JohnSGruber@gmail.com>
+John Hawkes <hawkes@sgi.com>
+John Hawkes <hawkes@sgi.com>
<hawkes@jackhammer.engr.sgi.com>
+John Hernandez <jay@chelsio.com>
+John Hughes <john@calva.com>                            <john@Calva.COM>
+John Leach <jfleach@jfleach.com>
+John Linville <linville@tuxdriver.com>
+John Linville <linville@tuxdriver.com>
<linville@linville-t41.local>
+John Linville <linville@tuxdriver.com>
<linville@laptop.(none)>
+John Linville <linville@tuxdriver.com>
<linville@linville-t43.mobile>
+John Maxin <john.maxin@nokia.com>
+John Reiser <jreiser@bitwagon.com>                      <jreiser@BitWagon.com>
+John Rogers <jgrogers@gmail.com>
+John Youn <john.youn@synopsys.com>
<John.Youn@synopsys.com>
+John Youn <john.youn@synopsys.com>                      <johnyoun@synopsys.com>
+Johnny Hsu <johnnyhsu@realtek.com>
 John Stultz <johnstul@us.ibm.com>
-Juha Yrjola <at solidboot.com>
+John Utz <john.utz@dmx.com>
+John Williams <john.williams@petalogix.com>
+Jonathan Brassow <jbrassow@redhat.com>
+Jonathan Brassow <jbrassow@redhat.com>
<jbrassow@f14.redhat.com>
+Jonathan Corbet <corbet@lwn.net>                        <corbet-v4l@lwn.net>
+Jon Burgess <jburgess777@gmail.com>
<jburgess777@googlemail.com>
+Jong-Hwan Choi <jhbird.choi@samsung.com>
+Jon Hellan <hellan@acm.org>
+Jon Loeliger <jdl@jdl.com>                              <linuxppc@jdl.com>
+Jon Maloy <jon.maloy@ericsson.com>
+Jon Masters <jonathan@jonmasters.org>                   <jcm@jonmasters.org>
+Jon Smirl <jonsmirl@gmail.com>                          <jonsmir@gmail.com>
+Jon Tollefson <kniht@linux.vnet.ibm.com>                <kniht@us.ibm.com>
+Jordan Hargrave <jordan_hargrave@dell.com>
<Jordan_Hargrave@Dell.com>
+Jorge Boncompte <jorge@dti2.net>
+Jorge Candelaria <jorge.candelaria@ti.com>
+Jorge Candelaria <jorge.candelaria@ti.com>              <x0107209@ti.com>
+Jörg Ahrens <joerg@hydrops.han.de>
+Jörg Albert <jal2@gmx.de>
+Jörg Dorchain <joerg@dorchain.net>
+Jörg Marx <joerg.marx@secunet.com>
+Jörg Neikes <j.neikes@midlandgate.de>
+Jörg Rödel <joerg.roedel@amd.com>
+Jörg Rödel <joerg.roedel@amd.com>                       <Joerg.Roedel@amd.com>
+Jörg Rödel <joerg.roedel@amd.com>                       <jroedel@lemmy.amd.com>
+Jörg Schirottke <master@kanotix.com>
+Jörg Schummer <joerg.schummer@web.de>
+Jörg Sommer <joerg@alea.gnuu.de>
+Jörg Willmann <joe@clnt.de>
+Joris van Rantwijk <jorispubl@xs4all.nl>                <jvrantwijk@xs4all.nl>
+Jörn Engel <joern@logfs.org>
+Jörn Engel <joern@wohnheim.fh-wedel.de>                 <joern@wh.fh-wedel.de>
+Jory Pratt <anarchy@gentoo.org>
+Josef Bacik <josef@redhat.com>                          <jwhiter@redhat.com>
+Josef Bacik <josef@redhat.com>                          <jbacik@redhat.com>
+Josef Sipek <jeffpc@josefsipek.net>
+Josef Sipek <jsipek@cs.sunysb.edu>
<jsipek@fsl.cs.sunysb.edu>
+José Fernández <josemariafg@gmail.com>
+José Gonçalves <jose.goncalves@inov.pt>
+José Santos <jrs@us.ibm.com>
+Joseph Chan <josephchan@via.com.tw>
+Joseph Chan <josephchan@via.com.tw>                     <JosephChan@via.com.tw>
+Joseph Cihula <joseph.cihula@intel.com>
+Joseph Gasparakis <joseph.gasparakis@intel.com>
+Joseph Myers <joseph@codesourcery.com>
+Josh Boyer <jwboyer@redhat.com>
+Josh Boyer <jwboyer@linux.vnet.ibm.com>                 <jdub@us.ibm.com>
+Josh Triplett <josht@linux.vnet.ibm.com>                <josht@us.ibm.com>
+Josh Triplett <josht@linux.vnet.ibm.com>                <josht@vnet.ibm.com>
+Joshua Bowman <bowmanj@augsburg.edu>
+Joshua Dillon <jvdillon@gmail.com>
+Joshua Pritikin <jpritikin@pobox.com>
+Jouni Högander <jouni.hogander@nokia.com>
+Jovi Zhang <bookjovi@gmail.com>
+Jozsef Fejes <fejes@joco.name>
+Juan Jesús García de Soria Lucena <skandalfo@gmail.com>
 Juha Yrjola <juha.yrjola@nokia.com>
 Juha Yrjola <juha.yrjola@solidboot.com>
+Juha Yrjola <juha.yrjola@solidboot.com>                 <at solidboot.com>
+Jürgen Beisert <jbe@pengutronix.de>
<j.beisert@pengutronix.de>
+Jürgen Fischer <fischer@linux-buechse.de>
+Jürgen Kilb <J.Kilb@phytec.de>
+Jürgen Kreileder <jk@blackdown.de>
+Jürgen Lambrecht <juergen.lambrecht@gmail.com>
+Jürgen Lock <nox@jelal.kn-bremen.de>
+Jürgen Mell <juergen.mell@t-online.de>
+Jürgen Schindele <linux@schindele.name>
+Jürg Häfliger <juergh@gmail.com>
+Julia Lawall <julia.lawall@lip6.fr>                     <Julia.Lawall@lip6.fr>
+Julien Blache <jb@jblache.org>
+Julien Krauth <krauth.julien@addi-data.com>
<Krauth.Julien@addi-data.com>
+Julien May <julien.may@miromico.ch>
<mailinglist@miromico.ch>
+Julien Tinnes <jt@cr0.org>                              <julien@cr0.org>
+Julio Merino Vidal <jmerino@ac.upc.edu>
+Jung-Ik Lee <jilee@google.com>
+Jun Gong <jgong@nuvoton.com>                            <JGong@nuvoton.com>
+Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
+Junio Hamano <gitster@pobox.com>
+Junjiro Okajima <hooanon05@yahoo.co.jp>
+Jürgen Orczykowski <juergen.orczykowski@siemens.com>
+Jurriaan <thunder7@xs4all.nl>
+Justin Chen <justin.chen@hp.com>
+Justin Chen <justin.chen@hp.com>
<jchen@hpdst41.cup.hp.com>
+Justin Mattock <justinmattock@gmail.com>
+
+### K #####
+Kai Jiang <Kai.Jiang@freescale.com>
+Kai Hsu <windsboy@gmail.com>
+Kailang Yang <kailang@realtek.com>
<kailang@realtek.com.tw>
+Kalin Kozhuharov <kalin@thinrope.net>
+Kalle Jokiniemi <kalle.jokiniemi@nokia.com>
<ext-kalle.jokiniemi@nokia.com>
+Kalle Valo <kalle.valo@iki.fi>                          <Kalle.Valo@iki.fi>
+Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
<kamalesh@linx.vnet.ibm.com>
+Karen Xie <kxie@chelsio.com>
+Karl Beldan <karl.beldan@gmail.com>
+Kashyap Desai <kashyap.desai@lsi.com>
+Kasper Pedersen <kernel@kasperkp.dk>                    <kkp2010@kasperkp.dk>
 Kay Sievers <kay.sievers@vrfy.org>
-Kenneth W Chen <kenneth.w.chen@intel.com>
-Koushik <raghavendra.koushik@neterion.com>
+Kazuhiro Suzuki <kaz@jp.fujitsu.com>
+Kazunori Miyazawa <kazunori@miyazawa.org>
+Keiichi Kii <k-keiichi@bx.jp.nec.com>
+Keir Fraser <keir.fraser@cl.cam.ac.uk>
<Keir.Fraser@cl.cam.ac.uk>
+Keir Fraser <keir.fraser@cl.cam.ac.uk>
<Keir.Fraser@xl.cam.ac.uk>
+Keith Mannthey <kmannth@us.ibm.com>
+Keith Milner <maillist@superlative.org>
+Keith Packard <keithp@keithp.com>
<keithp@neko.keithp.com>
+Kelly Daly <kelly@au.ibm.com>                           <kelly@au1.ibm.com>
+Keng-Yu Lin <kengyu@canonical.com>
<keng-yu.lin@canonical.com>
+Kenichi Horio <moattailk1@gmail.com>
+Ken-ichirou Matsuzawa <chamas@h4.dion.ne.jp>
+Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
<kaneshige.kenji@soft.fujitsu.com>
+Ken Johnson <ken@novell.com>
+Kenneth Chen <kenneth.w.chen@intel.com>
+Kenny Hsu <kenny.hsu@intel.com>
+Kenta Nakamura <kenta@c.csce.kyushu-u.ac.jp>
+Kent Liu <kent.liu@intel.com>
<kent.liu@linux.intel.com>
+Kerstin Jonsson <kerstin.jonsson@ericsson.com>
+Keshava Munegowda <keshava_mgowda@ti.com>               <Keshava_mgowda@ti.com>
+Kevin Cernekee <cernekee@gmail.com>                     <kpc.mtd@gmail.com>
+Kevin Hilman <khilman@mvista.com>
<khilman@com.rmk.(none)>
+Kevin Kissel <kevink@paralogos.com>
+Kevin Lloyd <klloyd@sierrawireless.com>
<linux@sierrawireless.com>
+Kevin Granade <kevin.granade@gmail.com>
+Kevin Page <linux-kernel@krp.org.uk>
+Kevin Tian <kevin.tian@intel.com>
+Kim Heino <kim.heino@bluegiga.com>
<Kim.Heino@bluegiga.com>
+Kirill Shutemov <kirill.shutemov@linux.intel.com>
+Kirill Smelkov <kirr@mns.spb.ru>
<kirr@landau.phys.spbu.ru>
+Kishore Kadiyala <kishore.kadiyala@ti.com>
+Kjetil Oftedal <oftedal@gmail.com>
+Klaas de Waal <klaas.de.waal@gmail.com>
+Klaus-Dieter Wacker <kdwacker@de.ibm.com>
+Klaus-Dieter Wacker <kdwacker@de.ibm.com>               <kdwacker@de.ibmc.om>
+Klaus Schmidinger <klaus.schmidinger@tvdr.de>
<Klaus.Schmidinger@tvdr.de>
+Klaus Schmidinger <klaus.schmidinger@cadsoft.de>
<Klaus.Schmidinger@cadsoft.de>
+Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
+Knut Petersen <knut_petersen@t-online.de>
<Knut_Petersen@t-online.de>
+Kohei Kaigai <kohei.kaigai@emea.nec.com>
<Kohei.Kaigai@emea.nec.com>
+Kohei Kaigai <kohei.kaigai@emea.nec.com>
<Kohei.Kaigai@eu.nec.com>
+Komuro <komurojun-mbn@nifty.com>                        <komurojun@nifty.com>
+Konrad Rzeszutek Wilk <konrad@darnok.org>               <ketuzsezr@darnok.org>
+Konstantin Baidarov <kbaidarov@ru.mvista.com>
+Kou Ishizaki <kou.ishizaki@toshiba.co.jp>               <kou.ishizaki
at toshiba.co.jp>
+Kristen Carlson Accardi <kristen@linux.intel.com>
<kristen.c.accardi@intel.com>
+Kristian Høgsberg <krh@redhat.com>
+Kristian Høgsberg <krh@redhat.com>
<krh@localhost.localdomain>
+Kristoffer Ericson <kristoffer.ericson@gmail.com>
<Kristoffer.Ericson@gmail.com>
+Kristoffer Ericson <kristoffer_e1@hotmail.com>
<Kristoffer_e1@com.rmk.(none)>
+Krisztian Kovacs <hidden@balabit.hu>
+Krzysztof Hałasa <khalasa@piap.pl>
+Krzysztof Hałasa <khc@pm.waw.pl>
+Krzysztof Helt <krzysztof.h1@wp.pl>
+Krzysztof Helt <krzysztof.h1@wp.pl>                     <krzysztof.h1 at wp.pl>
+Krzysztof Oledzki <ole@ans.pl>
+Krzysztof Oledzki <ole@ans.pl>                          <olenf@ans.pl>
+Krzysztof Oledzki <ole@ans.pl>                          <olel@ans.pl>
+Kumar Gala <galak@freescale.com>
<kumar.gala@freescale.com>
+Kumar Gala <galak@kernel.crashing.org>
<galak@gate.crashing.org>
+Kumar Gala <galak@kernel.crashing.org>                  <galak@spiff.(none)>
 Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
-Leonid I Ananiev <leonid.i.ananiev@intel.com>
+Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
<morimoto.kuninori@renesas.com>
+Kurt Bosch <kjb-temp-2005@gmx.de>
+Kurt Hackel <kurt.hackel@oracle.com>
<Kurt.Hackel@oracle.com>
+Kyle McMartin <kyle@redhat.com>                         <kmcmartin@redhat.com>
+Kyle McMartin <kyle@redhat.com>
<kyle@ihatethathostname.lab.bos.redhat.com>
+Kyle McMartin <kyle@mcmartin.ca>
<kyle@athena.road.mcmartin.ca>
+Kyle McMartin <kyle@mcmartin.ca>
<kyle@duet.int.mcmartin.ca>
+Kyle McMartin <kyle@mcmartin.ca>
<kyle@quicksilver.road.mcmartin.ca>
+Kyle McMartin <kyle@treachery.i.cabal.ca>               <kyle@mako.i.cabal.ca>
+Kyle McMartin <kyle@treachery.i.cabal.ca>
<kyle@shortfin.cabal.ca>
+Kyle McMartin <kyle@treachery.i.cabal.ca>
<kyle@minerva.i.cabal.ca>
+Kyle Moffett <kyle.d.moffett@boeing.com>
<Kyle.D.Moffett@boeing.com>
+Kylene Hall <kjhall@us.ibm.com>
+Ky Srinivasan <kys@microsoft.com>
+Kyungmin Park <kyungmin.park@samsung.com>
<kyungmin.aprk@samsung.com>
+
+### L #####
+Lachlan McIlroy <lachlan@sgi.com>
<lachlan@redback.melbourne.sgi.com>
+Lan Chunhe <b25806@freescale.com>
+Lan Chunhe <b25806@freescale.com>                       <B25806@freescale.com>
+Larry Finger <larry.finger@lwfinger.net>
<Larry.Finger@lwfinger.net>
+Lars Ellenberg <lars.ellenberg@linbit.com>
<Lars.Ellenberg@linbit.com>
+Lars Ericsson <lars_ericsson@telia.com>
<Lars_Ericsson@telia.com>
+László Attila Tóth <panther@balabit.hu>
+László Csécsy <boobaa@frugalware.org>
+Laurent Chavey <chavey@google.com>
+Laurentiu Tudor <laurentiu.tudor@freescale.com>
<Laurentiu.Tudor@freescale.com
+Laurent Meyer <meyerlau@fr.ibm.com>
+Laurent Riffard <laurent.riffard@free.fr>
+Laurent Vivier <laurent@lvivier.info>                   <Laurent@lvivier.info>
+Laurent Vivier <laurentvivier@wanadoo.fr>
<LaurentVivier@wanadoo.fr>
+Laurent Vivier <laurent.vivier@bull.net>
<Laurent.Vivier@bull.net>
+Lawrence Rust <lvr@softsystem.co.uk>
<lawrence@softsystem.co.uk>
+Leandro Costantino <lcostantino@gmail.com>
+Leed Aguilar Pena <leed.aguilar@ti.com>
+Lee Schermerhorn <lee.schermerhorn@hp.com>
<Lee.Schermerhorn@hp.com>
+Len Brown <len.brown@intel.com>
+Len Brown <len.brown@intel.com>
<lenb@toshiba.hsd1.ma.comcast.net>
+Len Brown <len.brown@intel.com>                         <lenb@toshiba.site>
+Len Brown <len.brown@intel.com>                         <lenb@t61.(none)>
+Lennert Buytenhek <buytenh@wantstofly.org>
<buytenh@org.rmk.(none)>
+Lennert Buytenhek <buytenh@wantstofly.org>
<buytenh+lkml@wantstofly.org>
+Leo Chen <leochen@broadcom.com>
+Leonard Norrgård <leonard.norrgard@refactor.fi>
+Leonid Ananiev <leonid.i.ananiev@intel.com>
+Leonid Fedorenchik <leonidsbox@gmail.com>
+Leon Woestenberg <leon.woestenberg@gmail.com>
+Leo White <lpw25@cam.ac.uk>
+Lepton Wu <ytht.net@gmail.com>
+Lesly A M <leslyam@ti.com>                              <x0080970@ti.com>
+Liam Girdwood <liam.girdwood@wolfsonmicro.com>
<Liam.Girdwood@wolfsonmicro.com>
+Liam Girdwood <liam.girdwood@wolfsonmicro.com>
<lg@opensource.wolfsonmicro.com>
+Liam Girdwood <liam.girdwood@wolfsonmicro.com>
<Liam.Girdwood@com.rmk.(none)>
+Liam Howlett <howlett@gmail.com>
+Liang Li <liang.li@windriver.com>
<Liang.Li@windriver.com>
 Linas Vepstas <linas@austin.ibm.com>
+Linus Torvalds <torvalds@linux-foundation.org>
<torvalds@woody.linux-foundation.org>
+Linus Torvalds <torvalds@osdl.org>                      <torvalds@evo.osdl.org>
+Linus Torvalds <torvalds@osdl.org>                      <torvalds@g5.osdl.org>
+Linus Torvalds <torvalds@osdl.org>
<torvalds@macmini.osdl.org>
+Linus Torvalds <torvalds@osdl.org>
<torvalds@merom.osdl.org>
+Linus Torvalds <torvalds@osdl.org>
<torvalds@ppc970.osdl.org>
+Linus Torvalds <torvalds@osdl.org>
<torvalds@ppc970.osdl.org.(none)>
+Linus Torvalds <torvalds@osdl.org>
<torvalds@quad.osdl.org>
+Linus Torvalds <torvalds@osdl.org>
<torvalds@woody.osdl.org>
+Ling Ma <ling.ma@intel.com>
+Linus Lüssing <linus.luessing@web.de>
+Libin Yang <libin.yang@amd.com>                         <Libin.Yang@amd.com>
+Libin Yang <libin.yang@amd.com>                         <Libin.yang@amd.com>
+Lino Sanfilippo <linosanfilippo@gmx.de>                 <LinoSanfilippo@gmx.de>
+Li Peng <peng.li@intel.com>                             <pengi.li@intel.com>
+Li Peng <peng.li@intel.com>
<peng.li@linux.intel.com>
+Li Tan <li.tan@intel.com>
+Li Shaohua <shaohua.li@intel.com>
+Liu Bo <liubo2009@cn.fujitsu.com>
+Liu Gang <gang.liu@freescale.com>
<Gang.Liu@freescale.com>
+Liu Gang <gang.liu@freescale.com>                       <b34182@freescale.com>
+Liu Gang <gang.liu@freescale.com>                       <B34182@freescale.com>
+Liu Shuo <shuo.liu@freescale.com>                       <b35362@freescale.com>
+Liu Yu <yu.liu@freescale.com>                           <Yu.Liu@freescale.com>
+Liu Yu <yu.liu@freescale.com>                           <b13201@freescale.com>
+Li YanBo <dreamfly281@gmail.com>
+Li Yang <leoli@freescale.com>
+Loren Lang <lorenl@alzatex.com>
+Lorenzo Hernandez García-Hierro <lorenzo@gnu.org>
+Lothar Waßmann <LW@KARO-electronics.de>
+Louis Rilling <louis.rilling@kerlabs.com>
<Louis.Rilling@kerlabs.com>
+Lubomir Bulej <lubomir.bulej@dsrg.mff.cuni.cz>
<bulej@nenya.ms.mff.cuni.cz>
+Lucas Correia Villa Real <lucasvr@gobolinux.org>
<lucasvr@org.rmk.(none)>
+Lucian Grijincu <lucian.grijincu@gmail.com>
+Luc Van Oostenryck <luc.vanoostenryck@looxix.net>       <lkml@looxix.net>
+Luis Carlos Cobo <luisca@cozybit.com>
+Luís Mendes <luis.p.mendes@gmail.com>
+Luis Ortiz <lfo@polyad.org>                             <lfo@Polyad.Org>
+Luis Rodriguez <mcgrof@frijolero.org>
+Luis Rodriguez <lrodriguez@atheros.com>
<lrodriguez@Atheros.com>
+Luis Rodriguez <rodrigue@qca.qualcomm.com>
<mcgrof@qca.qualcomm.com>
+Luiz Carlos Ramos <lramos.prof@yahoo.com.br>
<luizzramos@yahoo.com.br>
+Luiz Fernando Capitulino <lcapitulino@mandriva.com.br>
+Łukasz Stelmach <stlman@poczta.fm>
+Łukasz Stelmach <stelmacl@ee.pw.edu.pl>
+Łukasz Wojniłowicz <lukasz.wojnilowicz@gmail.com>
+Luke Browning <lukebrowning@us.ibm.com>
<lukebr@linux.vnet.ibm.com>
+Luotao Fu <l.fu@pengutronix.de>                         <lfu@pengutronix.de>
+
+### M #####
+Maciej Sosnowski <maciej.sosnowski@intel.com>
+Maciej Trela <maciej.trela@intel.com>
<Maciej.Trela@intel.com>
+Maciej Żenczykowski <maze@google.com>
+Mac Michaels <wmichaels@earthlink.net>
<wmichaels1@earthlink.net>
+Madhusudhan Chikkature <madhu.cr@ti.com>
+Madhuranath Iyengar <madhu.iyengar@qlogic.com>
<Madhu.Iyengar@qlogic.com>
+Madhuranath Iyengar <madhu.iyengar@qlogic.com>
<madhuranath.iyengar@qlogic.com>
+Maggie Zhang <xmzhang@brocade.com>
+Magnus Hörlin <magnus@alefors.se>
+Mahendra Singh Meena <mahendra.devel@gmail.com>
+Mahesh Rajashekhara <mahesh_rajashekhara@adaptec.com>
<Mahesh_Rajashekhara@adaptec.com>
+Majian Peng <majianpeng@gmail.com>
+Major Lee <major_lee@wistrom.com>                       <major_lee@wistron.com>
+Makito Shiokawa <lkhmkt@gmail.com>
+Malahal Naineni <malahal@us.ibm.com>
+Malcom Ashley <mlashley@gmail.com>
+Malcolm Parsons <malcolm.parsons@gmail.com>
+Malcolm Priestley <tvboxspy@gmail.com>
+Mallikarjuna Chilakala <mallikarjuna.chilakala@intel.com>
+Malte Schröder <maltesch@gmx.de>
+Masanori Goto <gotom@debian.or.jp>
+Mandeep Baines <msb@chromium.org>
+Manish Chopra <manish.chopra@qlogic.com>
+Manish Chopra <manish.chopra@qlogic.com>
<Manish.Chopra@qlogic.com>
+Manjunath Kondaiah <manjugk@ti.com>
+Manu Abraham <abraham.manu@gmail.com>
<abaraham.manu@gmail.com>
+Manu Abraham <manu@linuxtv.org>                         <manu@linxtv.org>
+Manuel Lauss <manuel.lauss@gmail.com>
<manuel.lauss@googlemail.com>
+Manuel Stahl <manuel.stahl@iis.fraunhofer.de>           <slm@iis.fraunhofer.de>
+Marc-André Hébert <hebert.marcandre@gmail.com>
+Marcel Apfelbaum <marcela@dev.mellanox.co.il>
<marcela@mellanox.co.il>
+Maciej Rozycki <macro@linux-mips.org>
+Maciej Rozycki <macro@mips.com>
+Marcin Gałczyński <marcin@galczynski.pl>
+Marcin Ślusarz    <marcin.slusarz@gmail.com>
+Marcio Alves <froooozen@gmail.com>
+Marco Porsch <marco.porsch@siemens.com>
+Marcos Paulo de Souza <marcos.mage@gmail.com>
+Marc Zyngier <marc.zyngier@arm.com>                     <Marc.Zyngier@arm.com>
+Marek Szyprowski <m.szyprowski@samsung.com>
<[m.szyprowski@samsung.com]>
+Marek Vašut <marek.vasut@gmail.com>
+Mario Limonciello <mario_limonciello@dell.com>
<Mario_Limonciello@Dell.com>
+Marius Gröger <marius.groeger@gmail.com>
<marius.groeger@googlemail.com>
+Marius Kotsbak <marius.kotsbak@gmail.com>
+Mark Allyn <mark.a.allyn@intel.com>
 Mark Brown <broonie@sirena.org.uk>
-Matthieu CASTET <castet.matthieu@free.fr>
+Mark Einon <mark.einon@gmail.com>                       <Mark.Einon@gmail.com>
+Mark Greer <mgreer@mvista.com>
+Mark Greer <mgreer@animalcreek.com>
+Mark Grondona <mgrondona@llnl.gov>
+Mark Gross <markgross@thegnar.org>
+Mark Fasheh <mark.fasheh@oracle.com>
<mfasheh@ca-build8.us.oracle.com>
+Mark Huang <mlhuang@cs.princeton.edu>
<mlhuang@CS.Princeton.EDU>
+Mark Langsdorf <mark.langsdorf@amd.com>
+Mark Lord <lkml@rtr.ca>                                 <liml@rtr.ca>
+Mark Rankilor <reodge@gmail.com>
+Mark Rutland <mark.rutland@arm.com>                     <Mark.Rutland@arm.com>
+Markus Brunner <super.firetwister@gmail.com>
<super.firetwister@googlemail.com>
+Mark Cox <mjc@redhat.com>
+Mark Hoffman <mhoffman@lightlink.com>
+Markus Metzger <markus.t.metzger@intel.com>
+Markus Metzger <markus.t.metzger@intel.com>
<markut.t.metzger@intel.com>
+Markus Pietrek <markus.pietrek@emtrion.de>
<Markus.Pietrek@emtrion.de>
+Markus Rechberger <markus.rechberger@amd.com>
<Markus.Rechberger@amd.com>
+Mark Salyzyn <mark_salyzyn@adaptec.com>
<Mark_Salyzyn@adaptec.com>
+Mark Salyzyn <mark_salyzyn@xyratex.com>
<mark_salyzyn@us.xyratex.com>
+Mark Ware <mware@elphinstone.net>
+Mark Weaver <mhw@netris.org>
+Mark Zhan <rongkai.zhan@windriver.com>
+Martin Decky <martin@decky.cz>                          <martin@desky.cz>
+Martin K. Petersen <martin.petersen@oracle.com>
<martin.petersen@ORACLE.COM>
+Martin Krause <martin.krause@tqs.de>                    <Martin.Krause@tqs.de>
+Martin Michlmayr <tbm@cyrius.com>                       <tbm@com.rmk.(none)>
+Martin Olsson <martin@minimum.se>                       <mnemo@minimum.se>
+Martin Peschke <mpeschke@linux.vnet.ibm.com>            <mp3@de.ibm.com>
+Martin Petermann <martin.petermann@de.ibm.com>
<martin@linux.vnet.ibm.com>
+Martin Petersen <martin.petersen@oracle.com>
+Martin Schwidefsky <schwidefsky@de.ibm.com>
<sky@mschwide.boeblingen.de.ibm.com>
+Martin Schwidefsky <schwidefsky@de.ibm.com>             <sky@skybook.(none)>
+Marton Illes <illes.marton@balabit.hu>
+Márton Németh <nm127@freemail.hu>
+Ma Rui <m00150988@huawei.com>
+Masahide Nakamura <nakam@linux-ipv6.org>
+Masahiro Asano <masano@tnes.nec.co.jp>
+Masakazu Mokuno <masakazu.mokuno@jp.sony.com>
<Masakazu.Mokuno@jp.sony.com>
+Masakazu Mokuno <masakazu.mokuno@jp.sony.com>           <mokuno@sm.sony.co.jp>
+Masaki Chikama <masaki.chikama@gmail.com>
+Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
<hiramatu@sdl.hitachi.co.jp>
+Masanori Goto <gotom@sanori.org>
+Masanori Itoh <itoumsn@nttdata.co.jp>
+Masatake Yamato <yamato@redhat.com>
+Masato Noguchi <masato.noguchi@jp.sony.com>
<Masato.Noguchi@jp.sony.com>
+Masayuki Gouji <gouji.masayuki@jp.fujitsu.com>
+Masayuki Ohtake <masa-korg@dsn.okisemi.com>
+Masoud Sharbiani <masouds@google.com>
+Mathias Fröhlich <mathias.froehlich@gmx.net>
<Mathias.Froehlich@gmx.net>
+Mathias Fröhlich <mathias.froehlich@gmx.net>
<Mathias.Froehlich@web.de>
+Mathieu Poirier <mathieu.poirier@linaro.org>
+Matheos Worku <matheos.worku@sun.com>                   <Matheos.Worku@Sun.COM>
+Matt Fleming <matt.fleming@intel.com>
<matt.fleming@linux.intel.com>
+Matthew Campbell <calvinmc@gmail.com>
+Matthew Creech <mlcreech@gmail.com>
+Matthew Ranostay <mranostay@embeddedalley.com>
<mranostay@embededalley.com>
+Matthew Tolentino <matthew.e.tolentino@intel.com>
+Matthew Wilcox <matthew.r.wilcox@intel.com>             <willy@linux.intel.com>
+Matthew Wilcox <willy@wil.cx>                           <matthew@wil.cx>
+Matthew Wilcox <willy@wil.cx>
<willy@rowlf.int.wil.cx>
+Matthias Brugger <matthias.bgg@gmail.com>
<mensch0815@googlemail.com>
+Matthias Brugger <matthias.bgg@gmail.com>
<matthias.bgg@googlemail.com>
+Matthias Dellweg <2500@gmx.de>
+Matthias Eckermann <mge@arcor.de>
+Matthias Fuchs <matthias.fuchs@esd.eu>
<matthias.fuchs@esd-electronics.com>
+Matthias Müller <matthias.mueller@rz.uni-karlsruhe.de>
+Matthias Schwarzott <zzam@gentoo.org>
+Matthieu Castet <castet.matthieu@free.fr>
+Matthieu Castet <matthieu.castet@parrot.com>
+Matthieu Castet <matthieu.castet@parrot.com>
<matthieu.castet@parrot.fr>
+Matti Aaltonen <matti.j.aaltonen@nokia.com>
+Mattia Dongili <malattia@linux.it>
+Matt Mooney <mfm@muteddisk.com>
+Matt Yourst <yourst@users.sourceforge.net>
+Maulik Mankad <maulik@ti.com>                           <x0082077@ti.com>
+Maurice Dawson <mauricedawson2699@gmail.com>
<mauricedawson2699@googlemail.com>
+Mauro Carvalho Chehab <maurochehab@gmail.com>           <mywing81@gmail.com>
+Max Asbock <masbock@linux.vnet.ibm.com>                 <masbock@us.ibm.com>
+Maximilian Attems <max@stro.at>
+Maximilian Attems <max@stro.at>                         <max@stro.a>
+Maximilian Attems <maks@sternwelten.at>
<janitor@sternwelten.at>
+Maxim Patlasov <maxim.patlasov@gmail.com>
+Maxin John <maxin.john@gmail.com>
+Max Vozeler <max@vozeler.com>                           <mvz@vozeler.com>
+Maynard Johnson <maynardj@us.ibm.com>                   <mpjohn@us.ibm.com>
 Mayuresh Janorkar <mayur@ti.com>
-Michael Buesch <m@bues.ch>
+Melchior Franz <mfranz@aon.at>
+Mel Gorman <mel@csn.ul.ie>
+Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
+Michael Albaugh <michael.albaugh@qlogic.com>
<Michael.Albaugh@qlogic.com>
+Michael Albaugh <michael.albaugh@qlogic.com>
<Michael.Albaugh@Qlogic.com>
+Michael Albaugh <michael.albaugh@qlogic.com>
<Michael.Albaugh@QLogic.com>
+Michael Brown <Michael_E_Brown@dell.com>
+Michael Büsch <m@bues.ch>
+Michael Büsch <m@bues.ch>                               <mbuesch@freenet.de>
+Michael Büsch <m@bues.ch>                               <mb@bu3sch.de>
+Michael Evans <mjevans1983@gmail.com>
+Michael Frysinger <vapier@gentoo.org>
+Michael Frysinger <vapier@gentoo.org>                   <vapier@org.rmk.(none)>
+Michael Frysinger <vapier.adi@gmail.com>
+Michael Frysinger <michael.frysinger@analog.com>
+Michael Hennerich <michael.hennerich@analog.com>
<Michael.Hennerich@analog.com>
+Michael Hernandez <michael.hernandez@qlogic.com>
+Michael Hernandez <michael.hernandez@qlogic.com>
<mike.hernandez@qlogic.com>
+Michael Holzheu <holzheu@linux.vnet.ibm.com>            <holzheu@de.ibm.com>
+Michael Holzheu <holzheu@linux.vnet.ibm.com>
<michael.holzheu@linux.vnet.ibm.com>
+Michael Johnson <johnsonm@rpath.com>
+Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
<freedesktop-bugzilla@mkarcher.dialup.fu-berlin.de>
+Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
<bugzilla-kernel@mkarcher.dialup.fu-berlin.de>
+Michael Kerrisk <mtk.manpages@gmail.com>
<mtk.manpages@googlemail.com>
+Michael Kerrisk <mtk-manpages@gmx.net>                  <mtk-lkml@gmx.net>
+Michael Labriola <michael.d.labriola@gmail.com>
+Michael Müller <michael@alice-dsl.net>                  <mueller
michael@alice-dsl.net>
+Michael ODonnell <michael.odonnell@stratus.com>
<Michael.ODonnell@stratus.com>
+Michael Opdenacker <michael.opdenacker@free-electrons.com>
<michael@free-electrons.com>
+Michael Opdenacker <michael.opdenacker@free-electrons.com>
<michael-lists@free-electrons.com>
+Michael Riepe <michael.riepe@gmail.com>
<michael.riepe@googlemail.com>
+Michael Robbins <mrobbins@mit.edu>                      <mrobbins@MIT.EDU>
+Michael Schimek <mschimek@gmx.at>
+Michael Schmitz <schmitzmic@gmail.com>
<schmitzmic@googlemail.com>
+Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
<schmitz@opal.biophys.uni-duesseldorf.de>
+Michael Stürmer <ms@mallorn.de>
+Michael Thalmeier <michael.thalmeier@sigmatek.at>
<Michael.Thalmeier@sigmatek.at>
+Michael Tokarev <mjt@tls.mks.ru>                        <mjt@tls.msk.ru>
+Michael Tsirkin <mst@redhat.com>
+Michael Tsirkin <mst@mellanox.co.il>
<mst@dev.mellanox.co.il>
+Michael Wang <mjwang@broadcom.com>
+Michael Williamson <michael.williamson@criticallink.com>
<[michael.williamson@criticallink.com]>
+Michał Górny <gentoo@mgorny.alt.pl>
+Michał Mirosław <mirq-linux@rere.qmqm.pl>
+Michał Mirosław <m.miroslaw@elka.pw.edu.pl>
<M.Miroslaw@elka.pw.edu.pl>
+Michał Wróbel <michal.wrobel@flytronic.pl>
+Michał Wróbel <michal.wrobel@flytronic.pl>
<Michal.Wrobel@flytronic.pl>
+Michał Wróbel <xmxwx@asn.pl>
+Michał Wronski <michal.wronski@gmail.com>
+Michał Wronski <michal.wronski@motorola.com>
<Michal.Wronski@motorola.com>
 Michel Dänzer <michel@tungstengraphics.com>
-Mitesh shah <mshah@teja.com>
+Michel Dänzer <michel.daenzer@amd.com>
+Michel Dänzer <daenzer@vmware.com>
+Michel Dänzer <michel@daenzer.net>
+Miguel Botón <waninkoko@gmail.com>
+Miguel Botón <waninkoko@gmail.com>                      <mboton.lkml@gmail.com>
+Miguel Botón <waninkoko@gmail.com>                      <mboton@gmail.com>
+Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>          <maxextreme@gmail.com>
+Mihai Donțu <mihai.dontu@gmail.com>
+Mikael Pettersson <mikpe@it.uu.se>                      <mikpe@csd.uu.se>
+Mika Korhonen <mikukkon@gmail.com>
<mika.j.korhonen@gmail.com>
+Mike Anderson <andmike@linux.vnet.ibm.com>              <andmike@us.ibm.com>
+Mike Marciniszyn <mike.marciniszyn@qlogic.com>
<mike.marciniszyn@qlogic.org>
+Mike Miller <mike.miller@hp.com>
+Mike Miller <mike.miller@hp.com>
<mikem@beardog.cce.hp.com>
+Mike Miller <mike.miller@hp.com>
<mikem@beardog.cca.cpqcorp.net>
+Mike Rapoport <mike@compulab.co.il>
<[mailto:mike@compulab.co.il]>
+Mike Thomas <rmthomas@sciolus.org>
+Mike Wolf <mjw@linux.vnet.ibm.com>                      <mjw@us.ibm.com>
+Mikhail Cherkashin <mcherkashin@ru.mvista.com>
<mcherkhashin@ru.mvista.com>
+Mikhail Ershov <mike.ershov@gmail.com>                  <Mike.Ershov@gmail.com>
+Mikhail Ershov <mike.ershov@gmail.com>                  <arcezed@gmail.com>
+Miklos Szeredi <mszeredi@suse.cz>                       <mszeredi@suse.de>
+Milan Plzik <milan.plzik@gmail.com>
+Miloslav Trmač <mitr@redhat.com>
+Mimi Zohar <zohar@linux.vnet.ibm.com>                   <zohar@us.ibm.com>
+Minchan Kim <minchan.kim@gmail.com>
+Ming Ling <ming.m.lin@intel.com>
+Mingming Cao <cmm@us.ibm.com>
+Mingming Cao <cmm@us.ibm.com>                           <cmm@u.ibm.com>
+Mingqiao Wu <mingqiao.wu@gmail.com>
+Mingqiao Wu <bridge.wu@marvell.com>
+Minskey Guo <chaohong_guo@linux.intel.com>
+Minskey Guo <chaohong_guo@linux.intel.com>
<chaohong.guo@linux.intel.com>
+Minskey Guo <minskey.guo@sun.com>                       <Minskey.Guo@Sun.COM>
+Miroslaw Walukiewicz <miroslaw.walukiewicz@intel.com>
<Miroslaw.Walukiewicz@intel.com>
+Misael Lopez Cruz <misael.lopez@ti.com>                 <x0052729@ti.com>
+Mitch Williams <mitch.a.williams@intel.com>
+Mitesh Shah <mshah@teja.com>
+Mitsuharu Takei <takei.andr@gmail.com>
+Mitsuru Kanda <mk@linux-ipv6.org>
+Mohamed Abbas <mohamed.abbas@intel.com>
+Mohamed Abbas <mohamed.abbas@intel.com>
<mabbas@linux.intel.com>
+Mohan Kumar <mohan@in.ibm.com>
+Moiz Sonasath <m-sonasath@ti.com>
+Moni Shoua <monis@voltaire.com>                         <monis@Voltaire.COM>
+Monty <xiphmont@xiph.org>
+Morten Larsen <m-larsen@post6.tele.dk>
 Morten Welinder <terra@gnome.org>
-Morten Welinder <welinder@anemone.rentec.com>
 Morten Welinder <welinder@darter.rentec.com>
+Morten Welinder <welinder@darter.rentec.com>
<welinder@anemone.rentec.com>
 Morten Welinder <welinder@troll.com>
+Motohiro Kosaki <kosaki.motohiro@jp.fujitsu.com>
+Moussa Ba <moussa.a.ba@gmail.com>
+Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
+Mutsumi Ishikawa <ishikawa@hanzubon.jp>
+Myron Stowe <myron.stowe@redhat.com>                    <mstowe@redhat.com>
 Mythri P K <mythripk@ti.com>
+
+### N #####
+Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
+Nagananda Chumbalkar <nagananda.chumbalkar@hp.com>
+Nagananda Chumbalkar <nagananda.chumbalkar@hp.com>
<Nagananda.Chumbalkar@hp.com>
+Namhyung Kim <namhyung@gmail.com>                       <namhyung ()
gmail ! com>
+Nan hai Zou <nanhai.zou@intel.com>
+Nan hai Zou <nanhai.zou@intel.com>                      <Nanhai.zou@intel.com>
+Narendra K <narendra_k@dell.com>                        <Narendra_K@Dell.com>
+Natalie Protasevich <natalie.protasevich@unisys.com>
<Natalie.Protasevich@unisys.com>
+Nate Diller <nate.diller@gmail.com>                     <nate.diler@gmail.com>
+Nathan Binkert <nate@binkert.org>
+Nathan Fontenot <nfont@austin.ibm.com>
+Nathaniel Turner <nate@houseofnate.net>
+Nathan Scott <nathans@sgi.com>                          <nathans@bruce>
+Naveen Rao <naveen.n.rao@linux.vnet.ibm.com>
+Naoaki Maeda <maeda.naoaki@jp.fujitsu.com>
+Naveen Krishna Chatradhi <ch.naveen@samsung.com>
+Neela Kolli <neela.kolli@engenio.com>
<Neela.Kolli@engenio.com>
+Neerav Parikh <neerav.parikh@intel.com>
+Neerav Parikh <neerav.parikh@intel.com>
<Neerav.Parikh@intel.com>
+Neil Brown <neilb@suse.de>
+Neil Brown <neilb@suse.de>                              <neilb@notabene.brown>
+Neil Horman <nhorman@tuxdriver.com>
+Neil Jones <neiljay@gmail.com>                          <NeilJay@gmail.com>
+Neil Munro <neilmunro@gmail.com>
+Németh Márton <nm127@freemail.hu>
 Nguyen Anh Quynh <aquynh@gmail.com>
-Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
+Nick Cheng <nick.cheng@areca.com.tw>
+Nicholas Nunley <nicholas.d.nunley@intel.com>
<nicholasx.d.nunley@intel.com>
+Nickolay Shmyrev <nshmyrev@yandex.ru>
+Nicholas Bellinger <nab@linux-iscsi.org>
+Nicholas Nunley <nicholas.d.nunley@intel.com>
+Nick Bowler <nbowler@elliptictech.com>
<nbowler@ellipticsemi.com>
+Nickolai Zeldovich <kolya@mit.edu>                      <kolya@MIT.EDU>
+Nick Piggin <npiggin@suse.de>
+Nick Piggin <npiggin@suse.de>                           <npiggen@suse.de>
+Nicolas Bellido <ml@acolin.be>                          <nb-ml@be.rmk.(none)>
+Nicolas Cavallari <nicolas.cavallari@lri.fr>
<Nicolas.Cavallari@lri.fr>
+Nicolas Cavallari <nicolas.cavallari@lri.fr>            <cavallar@lri.fr>
+Nicolas Dade <daden@symbol.com>
+Nicolas Dichtel <nicolas.dichtel@6wind.com>
+Nicolas Dichtel <nicolas.dichtel@6wind.com>
<nicolas.dichtel@dev.6wind.com>
+Nicolas Ferre <nicolas.ferre@atmel.com>
<nicolas.ferre@rfo.atmel.com>
+Nicolas Pitre <nico@cam.org>                            <nico@org.rmk.(none)>
+Nico Schottelius <nico-linuxsetlocalversion@schottelius.org>
<nico-kernel@schottelius.org>
+Nico Schottelius <nico-linuxsetlocalversion@schottelius.org>
<nico-linux-20090330@schottelius.org>
+Nigel Cunningham <nigel@suspend2.net>
<nigel@nigel.suspend2.net>
+Nikanth Karthikesan <knikanth@novell.com>               <KNikanth@novell.com>
+Nikitas Angelinas <nikitasangelinas@gmail.com>
<nikitasangelinas@googlemail.com>
+Nikolaus Voss <n.voss@weinmann.de>                      <N.Voss@weinmann.de>
+Nikunj Dadhania <nikunj@linux.vnet.ibm.com>
+Nir Tzachar <nir.tzachar@gmail.com>
+Nishanth Aravamudan <nacc@linux.vnet.ibm.com>           <nacc@us.ibm.com>
+Nishanth Menon <nm@ti.com>
+Nithin Sujir <nsujir@broadcom.com>
+Nitin Kamble <nitin.a.kamble@intel.com>
+Niv Sardi <xaiki@sgi.com>                               <xaiki@oss.sgi.com>
+Nobuhiro Iwamatsu <iwamatsu@nigauri.org>                <iwamatsu@nigarui.org>
+Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
<iwamatsu.nobuhiro@renesas.com>
+Nobuhiro Kusuno <n-kusuno@fc4.so-net.ne.jp>
+Nobuyuki Akiyama <akiyama.nobuyuk@jp.fujitsu.com>
+Nohee Ko <noheek@broadcom.com>
+No-one Important <nxhxzi702@sneakemail.com>
+No-one Important <nxhxzi702@sneakemail.com>             <nxhxzi702 at
sneakemail.com>
+Noriaki Takamiya <takamiya@po.ntts.co.jp>
+
+### O #####
+Olav Kongas <ok@artecdesign.ee>                         <ok@ee.rmk.(none)>
+Oldřich Jedlička <oldium.pro@seznam.cz>
+Oleg Drokin <oleg.drokin@sun.com>                       <Oleg.Drokin@Sun.COM>
+Oliver Hartkopp <oliver@hartkopp.net>
<socketcan@hartkopp.net>
+Oliver Neukum <oliver@neukum.org>                       <oliver@neukum.name>
+Olivier Blin <blino@mandriva.com>                       <oblin@mandriva.com>
+Olivier Danet <odanet@caramail.com>
+Olivier Grenie <olivier.grenie@dibcom.fr>
<Olivier.Grenie@dibcom.fr>
+Olivier Danet <odanet@caramail.com>                     <odanet at
caramail.com>
+Olof Johansson <olof@lixom.net>
+Omar Ramirez <omar.ramirez@ti.com>
+Ömer Sezgin Ugurlu <omer.ugurlu@a-kent.com>
+Om Prakash <omprakash.pal@stericsson.com>
+Ortwin Glück <odi@odi.ch>
+Oscar Medina <oscar.medina@motorola.com>
+Owain Ainsworth <zerooa@gmail.com>                      <zerooa@googlemail.com>
+Ozan Çağlayan <ozan@pardus.org.tr>
+
+### P #####
+Pablo Neira Ayuso <pablo@eurodev.net>
+Pablo Neira Ayuso <pablo@netfilter.org>                 <Pablo Neira Ayuso>
+Pádraig Brady <P@draigBrady.com>
+pageexec <pageexec@freemail.hu>
+Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>
<Palash.Bandyopadhyay@conexant.com>
+Pali Rohár <pali.rohar@gmail.com>
+Pancho Horrillo <pancho@pancho.name>
+Paolo Giarrusso <blaisorblade@yahoo.it>
+Parag Warudkar <parag.warudkar@gmail.com>               <parag.lkml@gmail.com>
+Patrice Vilchez <patrice.vilchez@atmel.com>
<patrice.vilchez@rfo.atmel.com>
+Patrick Boettcher <patrick.boettcher@parrot.com>
<Patrick.Boettcher@parrot.com>
+Patrick Boettcher <pboettcher@dibcom.fr>
<Patrick.Boettcher@dibcom.fr>
+Patrick Caulfield <pcaulfie@redhat.com>
+Patrick LoPresti <lopresti@gmail.com>
+Patrick McHardy <kaber@trash.net>
 Patrick Mochel <mochel@digitalimplant.org>
-Peter A Jonsson <pj@ludd.ltu.se>
-Peter Oruba <peter@oruba.de>
+Patrick Mochel <mochel@linux.intel.com>
<patrick.mochel@intel.com>
+Paul Clarke <pc@us.ibm.com>
+Paul Collins <paul@ondioline.org>
<paul@burly.ondioline.org>
+Paul Collins <paul@ondioline.org>
<paul@briny.ondioline.org>
+Paul Evans <leonerd@leonerd.org.uk>
+Paul Gortmaker <paul.gortmaker@gmail.com>
<paul.gortmaker@com.rmk.(none)>
+Paul Larson <pl@linux.vnet.ibm.com>                     <pl@us.ibm.com>
+Paul McKenney <paulmck@linux.vnet.ibm.com>
+Paul McKenney <paulmck@linux.vnet.ibm.com>              <paulmck@us.ibm.com>
+Paul Mundt <lethal@linux-sh.org>                        <lethal@Linux-SH.ORG>
+Paul Schroeder <pschroeder@uplogix.com>
+Paul Zalac <pzalac@gmail.com>
+Paul Zimmerman <paul.zimmerman@synopsys.com>            <paulz@synopsys.com>
+Paul Zimmerman <paul.zimmerman@synopsys.com>
<Paul.Zimmerman@synopsys.com>
+Pavel Machek <pavel@suse.cz>                            <pavel@suze.cz>
+Pavel Machek <pavel@suse.cz>                            <pavel@pavel@suse.cz>
+Pavel Panteleev <pp_84@mail.ru>
+Pavel Pisa <ppisa@pikron.com>
<ppisa4lists@pikron.com>
+Paweł Drewniak <czajernia@gmail.com>
+Pedro Alejandro López-Valencia <palopezv@gmail.com>
+Peer Chen <peerchen@gmail.com>
+Pekka Seppänen <pexu@kapsi.fi>
+Per Dalén <per.dalen@appeartv.com>
+Per Forlin <per.forlin@stericsson.com>
<per.friden@stericsson.com>
+Per Liden <per.liden@ericsson.com>
<per.liden@nospam.ericsson.com>
+Perry Piplani <perry.j.piplani@nasa.gov>
+Pete Eberlein <pete@sensoray.com>
+Peter De Schrijver <pdeschrijver@nvidia.com>
+Peter Foley <pefoley2@verizon.net>
+Peter Fürst <post@pfrst.de>
+Peter Horton <pdh@colonel-panic.org>
<zero@colonel-panic.org>
+Peter Hüwe <peterhuewe@gmx.de>                          <PeterHuewe@gmx.de>
+Peter Hüwe <peterhuewe@gmx.de>
<huewe.external.infineon@googlemail.com>
+Peter Ma <pma@mediamatech.com>
<peterma@mediamatech.com>
+Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
<oberpar@linux.vnet.ibm.com>
+Peter Ujfalusi <peter.ujfalusi@nokia.com>
<peter.ujfalusi@Nokia.com>
+Peter Jonsson <pj@ludd.ltu.se>
+Peter Korsgaard <jacmet@sunsite.dk>
 Peter Oruba <peter.oruba@amd.com>
+Peter Oruba <peter@oruba.de>
+Peter Ujfalusi <peter.ujfalusi@ti.com>
+Peter Waskiewicz <peter.p.waskiewicz.jr@intel.com>
+Peter Stokes <linux@dadeos.co.uk>
+Peter Teoh <htmldeveloper@gmail.com>
+Petr Baudis <pasky@ucw.cz>
+Petri Koistinen <petri.koistinen@iki.fi>
+Petr Písař <ppisar@redhat.com>
+Petr Stetiar <ynezz@true.cz>
+Petr Vandrovec <petr@vmware.com>                        <petr@vandrovec.name>
+Philby John <pjohn@mvista.com>                          <pjohn@in.mvista.com>
+Phil Edworthy <phil.edworthy@renesas.com>
<Phil.Edworthy@renesas.com>
+Phil Edworthy <phil.edworthy@renesas.com>
<PHIL.EDWORTHY@renesas.com>
+Phil Endecott <kernel@chezphil.org>
<phil_wueww_endecott@chezphil.org>
+Phil Endecott <kernel@chezphil.org>
<phil_twuce_endecott@chezphil.org>
+Phil Endecott <kernel@chezphil.org>
<spam_from_usb_devel@chezphil.org>
+Phil Endecott <kernel@chezphil.org>
<usb_endian_patch@chezphil.org>
+Philip Langdale <philipl@overt.org>
+Philipp Marek <philipp.marek@bmlv.gv.at>
+Philip Prindeville <philipp@redfish-solutions.com>
+Philip Prindeville <philipp@redfish-solutions.com>
<philipp_subx@redfish-solutions.com>
+Pierre Bailly <pierre@substantiel.fr>
+Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
<pierre-louis.bossart@intel.com>
+Pierre Ossman <drzeus@drzeus.cx>                        <drzeus-list@drzeus.cx>
+Pierre Ossman <drzeus@drzeus.cx>
<drzeus-list@cx.rmk.(none)>
+Pierre Peiffer <pierre.peiffer@bull.net>
<Pierre.Peiffer@bull.net>
+Ping Cheng <pinglinux@gmail.com>
+Porpoise Chiang <porpoise.chiang@gmail.com>
+Pradeep Dalvi <netdev@pradeepdalvi.com>
+Prakash Manjunathappa <prakash.pm@ti.com>
+Pranith Kumar <pranith.hacks@gmail.com>                 <bobby.prani@gmail.com>
+Prasad Joshi <prasadjoshi.linux@gmail.com>
<prasadjoshi124@gmail.com>
+Prasanna Panchamukhi <prasanna.panchamukhi@riverbed.com>
+Prashant Shah <pshah.mumbai@gmail.com>
 Praveen BP <praveenbp@ti.com>
+Pravin Bathija <pbathija@amcc.com>
+Pravin Shelar <pshelar@nicira.com>
+
+### Q #####
+Qiao Chong <qiaochong@loongson.cn>
+Qinghuang Feng <qhfeng.kernel@gmail.com>
+Qinghuang Feng <qhfeng.kernel@gmail.com>        <s3c24xx@gmail.com>
+Qing He <qing.he@intel.com>
+Qi Yong <qiyong@fc-cn.com>                      <qiyong@mail.fc-cn.com>
+Qu Fuping <qufuping@ercist.iscas.ac.cn>         <fs@ercist.iscas.ac.cn>
+
+### R #####
+Radek Pilař <mrkva@mrkva.eu>
+Rafał Bilski <rafalbilski@interia.pl>
+Rafael Wysocki <rjw@sisk.pl>
+Rafael Wysocki <rjw@sisk.pl>                            <rjwysocki@sisk.pl>
+Rafał Miłecki <zajec5@gmail.com>
+Raghavendra Koushik <raghavendra.koushik@neterion.com>
+Rainer Keller <mail@rainerkeller.de>
+RA-Jay Hung <jay_hung@ralinktech.com>
<Jay_Hung@ralinktech.com>
+Rajeev Kumar <rajeev-dlh.kumar@st.com>
+Rajesh Borundia <rajesh.borundia@qlogic.com>
+Rajesh Borundia <rajesh.borundia@qlogic.com>
<Rajesh.Borundia@qlogic.com>
 Rajesh Shah <rajesh.shah@intel.com>
+Rajkumar Nagarajan <rajkumar.nagarajan@ti.com>
 Ralf Baechle <ralf@linux-mips.org>
-Ralf Wildenhues <Ralf.Wildenhues@gmx.de>
+Ralf Baechle <ralf@linux-mips.org>                      <ralf@ongar.mips.com>
+Ralf Baechle <ralf@linux-mips.org>                      <ralf@mips.com>
+Ralf Baechle <ralf@linux-mips.org>
<ralf@denk.linux-mips.net>
+Ralf Rösch <ralf.roesch@rw-gmbh.de>
+Ralf Wildenhues <ralf.wildenhues@gmx.de>
<Ralf.Wildenhues@gmx.de>
+Ralph Wuerthner <ralphw@linux.vnet.ibm.com>             <rwuerthn@de.ibm.com>
+Ralph Wuerthner <ralphw@linux.vnet.ibm.com>
<ralph.wuerthner@de.ibm.com>
+Ramachandra Kuchimanchi <ramachandra.kuchimanchi@qlogic.com>
+Ramesh Babu K V <ramesh.babu@intel.com>
<ramesh.b.k.v@intel.com>
+Ramesh Babu K V <ramesh.babu@intel.com>
<ramesh.babu@linux.intel.com>
+Rami Rosen <ramirose@gmail.com>                         <roszenrami@gmail.com>
+Rami Rosen <ramirose@gmail.com>                         <rosenrami@gmail.com>
+Ramkrishna Vepa <ram.vepa@qlogic.com>
+Randy Dunlap <rdunlap@xenotime.net>
+Randy Dunlap <randy.dunlap@oracle.com>
<randy.dunlap@Oracle.COM>
+Randy Vinson <rvinson@mvista.com>
<rvinson@linuxbox.(none)>
+Raphaël Assénat <raph@8d.com>
+Raphaël Doursenaud <rdoursenaud@free.fr>
+Raúl Sánchez Siles <rss@barracuda.es>
+Ravikiran Thirumalai <kiran@scalex86.org>
+Ravinandan Arakali <ravinandan.arakali@neterion.com>
+Ravinandan Arakali <ravinandan.arakali@neterion.com>
<Ravinandan.Arakali@neterion.com>
+Ravi Nittala <ravi.nittala@in.ibm.com>
+Ravi Shankar <ravi.shankar@greenturtles.in>
+Raymond Mantchala <raymond.mantchala@streamvision.fr>
<raymond.mantchala@streamvision.ft>
+Raz Ben-Jehuda <raziebe@gmail.com>
+R. Durgadoss <durgadoss.r@intel.com>
+Reinette Chatre <reinette.chatre@intel.com>
+Reinette Chatre <reinette.chatre@intel.com>
<reinette.chatre@linux.intel.com>
+Reinhard Schwab <reinhard.schwab@aon.at>
 Rémi Denis-Courmont <rdenis@simphalempin.com>
-Rudolf Marek <R.Marek@sh.cvut.cz>
+Rémi Denis-Courmont <remi.denis-courmont@nokia.com>
+Rémi Denis-Courmont <remi.denis-courmont@nokia.com>
<remi.denis-courmont@nokia>
+Rémi Rérolle <rrerolle@lacie.com>
+Renaud Cerrato <r.cerrato@til-technologies.fr>
+René Bolldorf <xsecute@googlemail.com>
+René Bürgel <r.buergel@unicontrol.de>
+René Herman <rene.herman@gmail.com>
+René Herman <rene.herman@gmail.com>                     <rene.herman>
+René Rebe <rene@exactcode.de>
+Rene Sapiens <rene.sapiens@ti.com>
+Renquan Cheng <crq@kernel.org>
+Renquan Cheng <rqcheng@smu.edu.sg>
+Ricardo Cerqueira <v4l@cerqueira.org>                   <v4l\@cerqueira.org>
+Ricardo Labiaga <ricardo.labiaga@netapp.com>
<Ricardo.Labiaga@netapp.com>
+Ricardo Ribalda <ricardo.ribalda@gmail.com>
+Ricard Wanderlöf <ricard.wanderlof@axis.com>
+Richard Holden <aciddeath@gmail.com>
+Richard Kennedy <richard@rsk.demon.co.uk>
+Richard Lary <rlary@linux.vnet.ibm.com>
+Richard Lary <rlary@linux.vnet.ibm.com>                 <rlary@us.ibm.com>
+Richard Liu <richard.liu@st.com>
+Richard Musil <richard.musil@st.com>
+Richard Nauber <richard.nauber@gmail.com>               <RichardNauber@web.de>
+Richard Nauber <richard.nauber@gmail.com>
<richard.nauber@googlemail.com>
+Richard Purdie <rpurdie@rpsys.net>                      <richard@tim.rpsys.net>
+Richard Purdie <richard@openedhand.com>
<rpurdie@openedhand.com>
+Richard Purdie <richard@openedhand.com>
<rpurdie@net.rmk.(none)>
+Richard Retanubun <richardretanubun@ruggedcom.com>
<RichardRetanubun@RuggedCom.com>
+Richard Retanubun <richardretanubun@ruggedcom.com>
<RichardRetanubun@ruggedcom.com>
+Richard Röjfors <richard.rojfors@pelagicore.com>
+Richard Röjfors <richard.rojfors@mocean-labs.com>
<richard.rojfors.ext@mocean-labs.com>
+Richard Schütz <r.schtz@t-online.de>
+Richard Smith <richard@laptop.org>
+Richard Woodruff <r-woodruff2@ti.com>
+Rik van Riel <riel@redhat.com>
+Risto Suominen <risto.suominen@gmail.com>
<Risto.Suominen@gmail.com>
+Roald Frederickx <roald.frederickx@gmail.com>
<roald@sh-dt-4505.(none)>
+Roar Förde <roar.forde@stericsson.com>
+Robert Boone <rboone@rtd.com>
+Robert Day <rpjday@crashcourse.ca>
+Robert Jarzmik <robert.jarzmik@free.fr>                 <rjarzmik@free.fr>
+Robert Jennings <rcj@linux.vnet.ibm.com>                <rcjenn@austin.ibm.com>
+Robert Jennings <rcj@linux.vnet.ibm.com>                <rcjenn@us.ibm.com>
+Robert Johnson <rtjohnso@eecs.berkeley.edu>
+Robert Kenney <rmk@unh.edu>
+Robert Moore <robert.moore@intel.com>
+Robert Moore <robert.moore@intel.com>
<Robert.Moore@intel.com>
+Robert Olsson <robert.olsson@data.slu.se>
<Robert.Olsson@data.slu.se>
+Robert Peterson <rpeterso@redhat.com>
+Robert Schöne <robert.schoene@tu-dresden.de>
+Robin Johnson <robbat2@gentoo.org>
+Robin Holt <holt@sgi.com>
+Robin Holt <holt@sgi.com>                               <Robin@sgi.com>
+Rodrigues Goldwyn <rgoldwyn@suse.de>
+Roel Kluin <roel.kluin@gmail.com>
+Roel Kluin <roel.kluin@gmail.com>
<[mailto:roel.kluin@gmail.com]>
+Roel Kluin <roel.kluin@gmail.com>
<[roel.kluin@gmail.com]>
+Rogério Brito <rbrito@ime.usp.br>
+Roger Quadros <roger.quadros@nokia.com>
<ext-roger.quadros@nokia.com>
+Roland Dreier <roland@purestorage.com>
+Roland Dreier <roland@topspin.com>
<roland@eddore.topspincom.com>
+Roland Dreier <rolandd@cisco.com>                       <rdreier@cisco.com>
+Roland Kletzing <devzero@web.de>
+Roland Stigge <stigge@antcom.de>
+Rolf Eike Beer <eike-kernel@sf-tec.de>
<eike-hotplug@sf-tec.de>
+Romain Liévin <lkml@lievin.net>
+Roman Moravcik <roman.moravcik@gmail.com>
+Roman Zippel <zippel@linux-m68k.org>
+Romit Dasgupta <romit@ti.com>
+Rongjun Ying <rongjun.ying@csr.com>                     <Rongjun.Ying@csr.com>
+RongQing Li <roy.qing.li@gmail.com>
+Roy Zang <tie-fei.zang@freescale.com>
+R. Sricharan <r.sricharan@ti.com>
+Rudolf Marek <r.marek@sh.cvut.cz>                       <R.Marek@sh.cvut.cz>
+Rui Li <li.rui27@zte.com.cn>
 Rui Saraiva <rmps@joel.ist.utl.pt>
-Sachin P Sant <ssant@in.ibm.com>
-Sam Ravnborg <sam@mars.ravnborg.org>
+Ruiyi Zhang <ruiyi.zhang@atheros.com>
<Ruiyi.zhang@atheros.com>
+Ruiyi Zhang <ruiyi.zhang@atheros.com>
<Ruiyi.Zhang@Atheros.com>
+Rui Zhang <rui.zhang@intel.com>
+Rumen Bogdanovski <rumen@voicecho.com>
+Ruslan Pisarev <ruslanpisarev@gmail.com>                <ruslan@gmail.com>
+Russ Anderson <rja@sgi.com>                             <(rja@sgi.com)>
+Russ Anderson <rja@sgi.com>
<rja@efs.americas.sgi.com>
+Russ Dill <russ.dill@ti.com>                            <Russ.Dill@ti.com>
+Russ Dill <russ.dill@gmail.com>                         <Russ.Dill@gmail.com>
+Russ Dill <russ.dill@asu.edu>                           <Russ.Dill@asu.edu>
+Russell King <rmk@arm.linux.org.uk>
<rmk+lkml@arm.linux.org.uk>
+Russell King <rmk@arm.linux.org.uk>
<linux@arm.linux.org.uk>
+Russell King <rmk@arm.linux.org.uk>
<rmk+pcmcia@arm.linux.org.uk>
+Russell King <rmk@arm.linux.org.uk>
<rmk+kernel@arm.linux.org.uk>
+Russell King <rmk@arm.linux.org.uk>
<rmk@dyn-67.arm.linux.org.uk>
+Russell King <rmk@arm.linux.org.uk>
<root@dyn-67.arm.linux.org.uk>
+Russ Gorby <russ.gorby@intel.com>
<richardx.r.gorby@intel.com>
+Ryan Arnold <rsa@us.ibm.com>
+
+### S #####
+Sachin Sant <sachinp@in.ibm.com>
+Sachin Sant <sachinp@in.ibm.com>                        <ssant@in.ibm.com>
+Saeed Bishara <saeed@marvell.com>
+Saeed Bishara <saeed@marvell.com>
<saeed@ubuntu-saeed.il.marvell.com>
+Sage Weil <sage@newdream.net>                           <sage@newdream.ne>
+Sai Gopal <tsg321@gmail.com>
+Sakari Ailus <sakari.ailus@nokia.com>
<sakari.ailus@maxwell.research.nokia.com>
+Salman Qazi <sqazi@google.com>
+Sam Ravnborg <sam@ravnborg.org>                         <sam@mars.ravnborg.org>
+Sam Ravnborg <sam@ravnborg.org>
<sam@neptun.ravnborg.org>
+Sam Ravnborg <sam@ravnborg.org>
<sam@saturn.ravnborg.org>
+Sam Ravnborg <sam@ravnborg.org>
<sam@uranus.ravnborg.org>
+Sam Ravnborg <sam@ravnborg.org>                         <sam@mars.(none)>
+Sam Ravnborg <sam@ravnborg.org>                         <sam@neptun.(none)>
+Sam Robb <sam.robb@timesys.com>
+Samuel Cuella <samuel.cuella@supinfo.com>
+Samuel Ortiz <sameo@linux.intel.com>
<samuel.ortiz@intel.com>
+Samuel Ortiz <samuel@sortiz.org>                        <samuel@ortiz.org>
+Samuel Tõnu <tonu@jes.ee>
+Samuel Vale <srcvale@holoscopio.com>
+Sathya Prakash <sathya.prakash@lsi.com>
+Samson Yeung <fragmede@onepatchdown.net>
+Samuel Ortiz <sameo@linux.intel.com>
<sameol@linux.intel.com>
+Sandeep Gopalpet <sandeep.kumar@freescale.com>
<Sandeep.Kumar@freescale.com>
+Sandeep Sinha <sandeepksinha@gmail.com>
+Sandeep Paulraj <s-paulraj@ti.com>
+Santiago Leon <santil@linux.vnet.ibm.com>               <santil@us.ibm.com>
+Santosh Nayak <santoshprasadnayak@gmail.com>
+Sarah Sharp <sarah.a.sharp@linux.intel.com>
<sarah.a.sharp@intel.com>
+Sarveshwar Bandi <sarveshwar.bandi@emulex.com>
<Sarveshwar.Bandi@emulex.com>
 Sascha Hauer <s.hauer@pengutronix.de>
+Sascha Hauer <s.hauer@pengutronix.de>                   <sascha@de.rmk.(none)>
+Sasha Khapyorsky <sashak@alsa-project.org>
<sashakh@alsa-project.org>
+Sasha Khapyorsky <sashak@alsa-project.org>
<root@alsa0.alsa-project.org>
+Satoru Satoh <satoru.satoh@gmail.com>
 S.Çağlar Onur <caglar@pardus.org.tr>
+Scott Goldman <scottjg@vmware.com>
+Scott Jiang <scott.jiang.linux@gmail.com>
<[scott.jiang.linux@gmail.com]>
+Scott Thompson <postfailathushmaildotcom@yahoo.com>     <postfail@hushmail.com>
+Scott Thompson <postfailathushmaildotcom@yahoo.com>     <postfail at
hushmail.com>
+Sean Collins <sean@coreitpro.com>
+Sean Hefty <sean.hefty@intel.com>
+Sean Hefty <sean.hefty@intel.com>
<mshefty@ichips.intel.com>
+Sebastien Barre <sbarre@sdelcc.com>
+Sebastian Blanes <sebastian.blanes@gmail.com>
+Sebastian Ott <sebott@linux.vnet.ibm.com>               <sebott@de.ibm.com>
+Sebastian Pöhn <sebastian.poehn@belden.com>
+Sebastian Siewior <bigeasy@linutronix.de>
+Sebastian Siewior <sebastian@breakpoint.cc>             <bigeasy@breakpoint.cc>
+Sebastian Siewior <sebastian@breakpoint.cc>
<linux-crypto@ml.breakpoint.cc>
+Sebastian Siewior <sebastian@breakpoint.cc>
<cbe-oss-dev@ml.breakpoint.cc>
+Sebastian Siewior <sebastian@breakpoint.cc>
<netdev@ml.breakpoint.cc>
+Sebastian Siewior <sebastian@breakpoint.cc>
<linux+wireless@ml.breakpoint.cc>
+Sebastian Siewior <sebastian@breakpoint.cc>
<frame+buffer@ml.breakpoint.cc>
+Sebastian Siewior <sebastian@breakpoint.cc>             <lkml@ml.breakpoint.cc>
+Sebastien Dugué <sebastien.dugue@bull.net>
+Sebastien Hinderer <sebastien.hinderer@ens-lyon.org>
<Sebastien.Hinderer@ens-lyon.org>
+Sedat Dilek <sedat.dilek@gmail.com>
<sedat.dilek@googlemail.com>
+Sedji Gaouaou <sedji.gaouaou@atmel.com>
+Séguier Régis <rseguier@e-teleport.net>
+Seokmann Ju <sju@lsil.com>
+Seokmann Ju <sju@lsil.com>                              <Seokmann.Ju@lsil.com>
+Seokmann Ju <seokmann.ju@engenio.com>
<Seokmann.Ju@engenio.com>
+Serge Hallyn <serge@hallyn.com>
+Serge Hallyn <sergeh@us.ibm.com>                        <serue@us.ibm.com>
+Sergei Shtylyov <sshtylyov@ru.mvista.com>
+Sergei Shtylyov <sshtylyov@ru.mvista.com>
<[sshtylyov@ru.mvista.com]>
+Sergei Trofimovich <slyich@gmail.com>
+Sergei Shtylyov <sshtylyov@ru.mvista.com>
+Sergej Stepanov <Sergej.Stepanov@ids.de>
+Serge Suchkov <serge.a.s@tochka.ru>                     <Serge.A.S@tochka.ru>
+Sergio Fortier <sergiofortier@yahoo.com.br>
+Sergio Luis <sergio@larces.uece.br>                     <sergio@uece.br>
+Servaas Vandenberghe <vdb128@picaros.org>
+Shahar Levi <shahar_levi@ti.com>
+Shane Huang <shane.huang@amd.com>                       <Shane.Huang@amd.com>
+Shani Moideen <shani.moideen@wipro.com>
+Shaohui Xie <shaohui.xie@freescale.com>                 <b21989@freescale.com>
+Shannon Nelson <shannon.nelson@intel.com>
+Shaohui Xie <shaohui.xie@freescale.com>
<Shaohui.Xie@freescale.com>
+Shawn Lu <shawn.lu@ericsson.com>
+Sheng Yang <sheng.yang@intel.com>                       <sheng@linux.intel.com>
+Sheng Yongjie <samsheng@trident.com.cn>
+Shin-ichiro Kawasaki <kawasaki@juno.dti.ne.jp>
+Shirish Pargaonkar <shirishpargaonkar@gmail.com>
+Shirish Pargaonkar <shirishpargaonkar@gmail.com>        <shirishp@gmail.com>
+Shirley Ma <mashirle@us.ibm.com>                        <xma@us.ibm.com>
+Shoichi Tamuki <tamuki@linet.gr.jp>
+Shubhrajyoti Datta <shubhrajyoti@ti.com>
+Shubhrajyoti Datta <shubhrajyoti@ti.com>                <a0393217@india.ti.com>
+Shuya Maeda <maeda-sxb@necst.nec.co.jp>
+Shyam Iyer <shyam_iyer@dell.com>                        <Shyam_Iyer@Dell.com>
+Shyam Sundar <shyam.sundar@qlogic.com>
<shyam.sunder@qlogic.com>
+Sifram Rajas <sifram.rajas@gmail.com>
+Sigmund Augdal <sigmund@snap.tv>
+Simon Arlott <simon@fire.lp0.eu>                        <simon@fire.lp0.eux>
+Simon Farnsworth <simon.farnsworth@onelan.co.uk>
<simon.farnsworth@onelan.com>
+Simon Horman <horms@verge.net.au>
+Simon Horman <horms@verge.net.au>                       <horms@vergenet.net>
 Simon Kelley <simon@thekelleys.org.uk>
+Simon Polette <spolette@adetelgroup.com>
+Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
<siwu@hrz.tu-chemnitz.de>
+Sivakumar Subramani <sivakumar.subramani@neterion.com>
<Sivakumar.Subramani@neterion.com>
+Sjur Brændeland <sjur.brandeland@stericsson.com>
+Solofo Ramangalahy <solofo.ramangalahy@bull.net>
<Solofo.Ramangalahy@bull.net>
+Sonic Zhang <sonic.zhang@analog.com>
<Sonic.Zhang@analog.com>
+Sonny Rao <sonnyrao@linux.vnet.ibm.com>                 <sonnyrao@us.ibm.com>
+Soyoung Park <speattle@yahoo.com>
+Sreenivasa Honnur <sreenivasa.honnur@neterion.com>
<Sreenivasa.Honnur@neterion.com>
+Sreenivas Bagalkote <sreenivas.bagalkote@engenio.com>
<Sreenivas.Bagalkote@engenio.com>
+Sridhar Samudrala <sri@us.ibm.com>                      <samudrala@us.ibm.com>
+Srikar Bhavanarayana <ext-srikar.1.bhavanarayana@nokia.com>
+Srimugunthan Dhandapani <srimugunthan.dhandapani@gmail.com>
+Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
+Srinivasa Deevi <srinivasa.deevi@conexant.com>
<Srinivasa.Deevi@conexant.com>
+Srinivasa D S <srinivasa@in.ibm.com>
+Srinivas Gowda <srinivas_g_gowda@dell.com>
+Srinivas Kandagatla <srinivas.kandagatla@st.com>
+Sriramakrishnan Govindarajan <srk@ti.com>
+Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>           <vatsa@in.ibm.com>
+Stanislaw Gruszka <stf_xl@wp.pl>                        <stf_xl@pop3.wp.pl>
+Stanley Miao <stanley.miao@windriver.com>
+Stefan Assmann <stefan.bader@de.ibm.com>
<Stefan.Bader@de.ibm.com>
+Stefan Bosak <stefan.bosak@gmail.com>
+Stefan Lippers-Hollmann <s.l-h@gmx.de>                  <s.L-H@gmx.de>
+Stefan Richter <stefanr@s5r6.in-berlin.de>
+#Kristian Høgsberg, Stefan Richter <stefanr@s5r6.in-berlin.de>
+Steinar Gunderson <sgunderson@bigfoot.com>
+Stephan Bärwolf <stephan.baerwolf@tu-ilmenau.de>
+Stephane Duverger <stephane.duverger@gmail.com>
+Stephane Eranian <eranian@google.com>
+Stephane Eranian <stephane.eranian@hp.com>              <eranian@hpl.hp.com>
+Stephane Eranian  <eranian@gmail.com>
<eranian@googlemail.com>
 Stéphane Witzmann <stephane.witzmann@ubpmes.univ-bpclermont.fr>
+Stefan Roscher <ossrosch@linux.vnet.ibm.com>
<stefan.roscher@de.ibm.com>
+Stefan Roscher <ossrosch@linux.vnet.ibm.com>
<stefan.roscher at de.ibm.com>
+Stephen Cameron <steve.cameron@hp.com>
<scameron@beardog.cce.hp.com>
+Stephen Cameron <steve.cameron@hp.com>
<scameron@beardog.cca.cpqcorp.net>
+Stephen Cameron <steve.cameron@hp.com>
<scameron@quandary.americas.cpqcorp.net>
+Stephen Cameron <steve.cameron@hp.com>                  <StephenM.Cameron>
 Stephen Hemminger <shemminger@osdl.org>
+Stephen Hemminger <shemminger@vyatta.com>
+Stephen Hemminger <shemminger@linux-foundation.org>
<shemminger@linux.foundation.org>
+Stephen Hemminger <shemminger@vyatta.com>               <sheminger@vyatta.com>
+Stephen Hemminger <shemminger@vyatta.com>
<stephen.hemminger@vyatta.com>
+Stephen Hemminger <shemminger@osdl.org>
<shemminger@dxpl.pdx.osdl.net>
+Stephen Rothwell <sfr@canb.auug.org.au>
+Steve Dickson <steved@redhat.com>                       <SteveD@redhat.com>
+Steve French <sfrench@us.ibm.com>                       <smfltc@us.ibm.com>
+Steve French <sfrench@hera.kernel.org>                  <stevef@stevef95>
+Steve French <sfrench@us.ibm.com>
<stevef@smf-gateway.(none)>
+Steve Grubb <sgrubb@redhat.com>                         <sgrubb redhat com>
+Steve Magnani <steve@digidescorp.com>
+Steven Falco <sfalco@harris.com>
+Steven Finney <steven.finney@palm.com>
<Steven.Finney@palm.com>
+Steven Hill <sjhill@realitydiluted.com>
+Steven King <sfking@fdwdc.com>
+Steven Li <steven.li@atheros.com>                       <Steven.Li@Atheros.com>
+Steven Miao <realmz6@gmail.com>
+Steven Rostedt <srostedt@redhat.com>                    <srotedt@redhat.com>
+Steven Rostedt <srostedt@redhat.com>
<srostedt@srostedt@redhat.com>
+Steven Whitehouse <steve@chygwyn.com>
<steve@men-an-tol.chygwyn.com>
+Steven Whitehouse <steve@chygwyn.com>
<steve@dolmen.chygwyn.com>
+Stuart Hayes <stuart_hayes@dell.com>                    <Stuart_Hayes@dell.com>
+Stuart Hayes <stuart_hayes@dell.com>                    <Stuart_Hayes@Dell.com>
+Stuart Menefy <stuart.menefy@st.com>
+Stuart Yoder <stuart.yoder@freescale.com>               <b08248@freescale.com>
+Sucheta Chakraborty <sucheta@dut6195.unminc.com>
<sucheta@dut4145.unminc.com>
+Sudhakar Rajashekhara <sudhakar.raj@ti.com>
+Sujith Manoharan <sujith.manoharan@atheros.com>
<Sujith.Manoharan@atheros.com>
+Sujith Thomas <sujith.thomas@intel.com>
+Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
+Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>        <sukadev@us.ibm.com>
 Sumit Semwal <sumit.semwal@ti.com>
+Sundar Iyer <sundar.iyer@stericsson.com>
+Sunil Mushran <sunil.mushran@oracle.com>
<sunil.musran@oracle.com>
+Sunil Mushran <sunil.mushran@oracle.com>
<Sunil.Mushran@oracle.com>
+Suresh Siddha <suresh.b.siddha@intel.com>
+Surya Prabhakar <surya.prabhakar@wipro.com>
+Susan Gao <sgao@opensource.wolfsonmicro.com>
+Suzuki Poulose <suzuki@in.ibm.com>
+Suzuki Poulose <suzuki@in.ibm.com>                      <suzuki@In.ibm.com>
+Suzuki Poulose <suzuki@in.ibm.com>
<suzuki@linux.vnet.ibm.com>
+S. Venkatraman <svenkatr@ti.com>
+Syed Mohammed Khasim <khasim@ti.com>
+Syed Mohammed Khasim <khasim@ti.com>                    <x0khasim@ti.com>
+Sylvain Foret <sylvain.foret@anu.edu.au>
+Syuhei Kumano <kumano.prog@gmail.com>
+
+### T #####
+Takahiro Shimizu <tshimizu818@gmail.com>
+Takahito Hirano <hiranotaka@zng.info>
+Takahito Hirano <hiranotaka@zng.info>                   <hiranotaka@zng.jp>
+Takahiro Kurosawa <kurosawa@valinux.co.jp>
+Takahiro Muneda <muneda.takahiro@jp.fujitsu.com>
+Takashi Iwai <tiwai@suse.de>                            <tiwai@alsa2.suse.de>
+Takashi Iwai <tiwai@suse.de>                            <tiwai@alsa3.local>
+Takashi Ohmasa <ohmasa.takashi@jp.panasonic.com>
<ohmasa.takashi@com.rmk.(none)>
+Takashi Sato <t-sato@yk.jp.nec.com>                     <sho@tnes.nec.co.jp>
+Takashi Yamamoto <yamamoto@valinux.co.jp>
+Takashi Yamamoto <takashia.yamamoto@jp.sony.com>
<TakashiA.Yamamoto@jp.sony.com>
+Takashi Yoshii <takasi-y@ops.dti.ne.jp>
+Takashi Yoshii <takashi.yoshii.zj@renesas.com>
+Takashi Yoshii <takashi.yoshii.zj@renesas.com>
<yoshii.takashi@renesas.com>
+Taku Izumi <izumi.taku@jp.fujitsu.com>
<izumi.taku@jp.fugitsu.com>
+Taku Izumi <izumi.taku@jp.fujitsu.com>
<izumi2005@soft.fujitsu.com>
+Tang Kai <tangk73@hotmail.com>
+Tang Yuantian <yuantian.tang@freescale.com>
<Yuantian.Tang@freescale.com>
+Tang Yuantian <yuantian.tang@freescale.com>             <B29983@freescale.com>
 Tejun Heo <htejun@gmail.com>
+Teru Kamogashira <teru@sodan.ecc.u-tokyo.ac.jp>
+Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
<penguin-kernel@I-love.SAKURA.ne.jp>
+Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
<from-linux-kernel@i-love.sakura.ne.jp>
+Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
<from-tomoyo-users-en@I-love.SAKURA.ne.jp>
+Theodore Kilgore <kilgota@auburn.edu>
<kilgota@banach.math.auburn.edu>
+Theodore Ts'o <tytso@mit.edu>
+Theodore Ts'o <tytso@mit.edu>                           <tytso@MIT.EDU>
+Thibault Le Meur <thibault.lemeur@supelec.fr>
<Thibault.LeMeur@supelec.fr>
+Thibaut Varene <varenet@parisc-linux.org>
+Thibaut Varene <varenet@parisc-linux.org>
<T-Bone@parisc-linux.org>
+Thiemo Nagel <thiemo.nagel@ph.tum.de>
+Thierry Merle <thierry.merle@free.fr>
+Thomas Downing <thomas.downing@ipc.com>
<Thomas.Downing@ipc.com>
+Thomas Gleixner <tglx@linutronix.de>
+Thomas Gleixner <tglx@linutronix.de>                    <tglxlinutronix.de>
+Thomas Gleixner <tglx@linutronix.de>                    <[tglx@linutronix.de]>
+Thomas Gleixner <tglx@linutronix.de>
<tglx@tglx.tec.linutronix.de>
+Thomas Gleixner <tglx@linutronix.de>
<tglx@mtd.linutronix.de>
+Thomas Gleixner <tglx@linutronix.de>
<tglx@cruncher.tec.linutronix.de>
+Thomas Gleixner <tglx@linutronix.de>
<tglx@inhell4.tec.linutronix.de>
+Thomas Gleixner <tglx@linutronix.de>                    <tglx@inhell4.(none)>
+Thomas Gleixner <tglx@linutronix.de>
<tglx@inhelltoy.tec.linutronix.de>
+Thomas Gleixner <tglx@linutronix.de>                    <tglx@chaos.(none)>
+Thomas Gleixner <tglx@linutronix.de>                    <tglx@apollo.(none)>
 Thomas Graf <tgraf@suug.ch>
+Thomas Graf <tgraf@suug.ch>                             <tgr@axs.localdomain>
+Thomas Hellstrom <thomas@tungstengraphics.com>
<thomas-at-tungstengraphics-dot-com>
+Thomas Hommel <thomas.hommel@gefanuc.com>
<Thomas.Hommel@gefanuc.com>
+Thomas Kaiser <linux-dvb@kaiser-linux.li>               <linux-dvb AT
kaiser-linux.li>
+Thomas Klein <tklein@de.ibm.com>                        <osstklei@de.ibm.com>
+Thomas Knobloch <knobloch@siemens.com>
+Thomas Kunze <thommycheck@gmx.de>
<tkunze@tkunze-desktop.(none)>
+Thomas Mingarelli <thomas.mingarelli@hp.com>
<Thomas.Mingarelli@hp.com>
+Thomas Pedersen <twpedersen@qca.qualcomm.com>
<c_tpeder@qca.qualcomm.com>
+Thomas Reim <reimth@gmail.com>                          <reimth@googlemail.com>
+Thomas Reitmayr <treitmayr@devbase.at>                  <thomas@devbase.at>
+Thomas Sailer <t.sailer@alumni.ethz.ch>                 <sailer@ife.ee.ethz.ch>
+Thomas Schorpp <thomas.schorpp@gmail.com>
<thomas.schorpp@googlemail.com>
+Thomas Talpey <thomas.talpey@netapp.com>
<Thomas.Talpey@netapp.com>
+Thomas Vögtle <tv@lio96.de>
+Thorsten März <torte@netztorte.de>
+Till Harbaum <till@harbaum.org>                         <Till@Harbaum.org>
+Till Harbaum <till@harbaum.org>                         <lists@harbaum.org>
+Tim Abbott <tabbott@mit.edu>                            <tabbott@MIT.EDU>
+Tim Ansell <mithro@mithis.com>
+Timofei Bondarenko <tim@ipi.ac.ru>
+Timo Teräs <timo.teras@iki.fi>
+Timothy Nelson <wayland@wayland.id.au>
+Timo Warns <warns@pre-sense.de>                         <Warns@pre-sense.de>
+Tim Shimmin <tes@sgi.com>
<tes@chook.melbourne.sgi.com>
+Tim Shimmin <tes@sgi.com>                               <tes@oss.sgi.com>
+Tina Yang <tina.yang@oracle.com>                        <Tina.Yang@oracle.com>
+TJ <linux@tjworld.net>                                  <ubuntu@tjworld.net>
+Tobias Brunner <tobias@strongswan.org>
<tobias.brunner@strongswan.org>
+Tobias Klauser <tklauser@distanz.ch>
<tklauser@xenon.tklauser.home>
+Todd Poynor <toddpoynor@google.com>
+Todd Poynor <tpoynor@mvista.com>
<tpoynor@com.rmk.(none)>
+Tomáš Čech <sleep_walker@suse.cz>
+Tomáš Čech <sleep_walker@suse.cz>                       <walker@suse.cz>
+Tomáš Petr <tom-petr@seznam.cz>
+Tomas Winkler <tomas.winkler@intel.com>
+Tomasz Kantecki <tomasz.kantecki@intel.com>
+Tom Callaway <tcallawa@redhat.com>
+Tomi Valkeinen <tomi.valkeinen@nokia.com>
<Tomi.Valkeinen@nokia.com>
+Tom Leiming <tom.leiming@gmail.com>
+Tom Morrison <tmorrison@empirix.com>
+Tommy Christensen <tommy.christensen@tpack.net>
+Tomonori Fujita <fujita.tomonori@lab.ntt.co.jp>
+Tomonori Fujita <fujita@tulip.osrg.net>
+Tomonori Fujita <tomof@acm.org>
+Tomoya Morinaga <tomoya.rohm@gmail.com>
+Tom Talpey <tmt@netapp.com>                             <talpey@netapp.com>
+Tom Tucker <tom@ogc.us>
<tom@opengridcomputing.com>
+Tom Zanussi <zanussi@comcast.net>                       <zanussi@comcast.ne>
+Tony Burrows <tony@tonyburrows.com>
+Tony Jones <tonyj@suse.de>
+Tony Lindgren <tony@atomide.com>                        <at atomide.com>
+Tony Lindgren <tony@atomide.com>                        <tmlind@baageli.(none)>
+Tony Lindgren <tony@atomide.com>                        <Lopez>
+Tony Lindgren <tony@atomide.com>                        <Nayak>
 Tony Luck <tony.luck@intel.com>
+Tony Luck <tony.luck@intel.com>
<aegl@agluck-lia64.sc.intel.com>
+Tony Luck <tony.luck@intel.com>
<aegl@agluck-desktop.(none)>
+Tony Sim <chinyeow.sim.xt@renesas.com>
+Toralf Förster <toralf.foerster@gmx.de>
+Torsten Mehnert <tmehnert@eckelmann.de>
+Torsten Mehnert <tmehnert@eckelmann.de>
<T.Mehnert@eckelmann.de>
+Toru Uchiyama <uchiyama.toru@jp.fujitsu.com>
+Toshihiro Hanawa <hanawa@ccs.tsukuba.ac.jp>
+Toshinobu Sugioka <sugioka@itonet.co.jp>
+Trevor Highland <thighlan@gmail.com>
<trevor.highland@gmail.com>
+Trond Myklebust <trond.myklebust@netapp.com>
<Trond.Myklebust@netapp.com>
+T. Sefzick <t.sefzick@fz-juelich.de>
+Tseng-Hui Lin <thlin@linux.vnet.ibm.com>
 Tsuneo Yoshioka <Tsuneo.Yoshioka@f-secure.com>
+
+### U #####
+Uk Kim <w0806.kim@samsung.com>
+Uli Luckas <u.luckas@road.de>                           <u.luckas@road-gmbh.de>
+Ulrich Dangel <uli-kernel@spamt.net>                    <uli@spamt.net>
+Ulrich Müller <ulm@kph.uni-mainz.de>
+Ursula Braun <braunu@de.ibm.com>
+Ursula Braun <braunu@de.ibm.com>
<ursula.braun@de.ibm.com>
+Ursula Braun <braunu@de.ibm.com>
<ubraun@linux.vnet.ibm.com>
+Utako Kusaka <u-kusaka@wm.jp.nec.com>                   <utako@tnes.nec.co.jp>
+Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
 Uwe Kleine-König <ukleinek@informatik.uni-freiburg.de>
-Uwe Kleine-König <ukl@pengutronix.de>
-Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
-Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
-Takashi YOSHII <takashi.yoshii.zj@renesas.com>
+Uwe Kleine-König <uwe.kleine-koenig@digi.com>
<Uwe.Kleine-Koenig@digi.com>
+Uwe Zeisberger  <uwe_zeisberger@digi.com>
<Uwe_Zeisberger@digi.com>
+Uwe Kleine-König <u.kleine-koenig@pengutronix.de>       <ukl@pengutronix.de>
+
+### V #####
+Valdis Kletnieks <valdis.kletnieks@vt.edu>
<Valdis.Kletnieks@vt.edu>
+Valentine Barshak <vbarshak@mvista.com>
<vbarshak@ru.mvista.com>
+Valentin Sitdikov <valentin.sitdikov@siemens.com>
+Valery Podrezov <valery.a.podrezov@intel.com>
+V. Ananda Krishnan <mansarov@us.ibm.com>
+Varun Wadekar <vwadekar@nvidia.com>
+Vasu Dev <vasu.dev@intel.com>
<vasu.dev@linux.intel.com>
+Venkateswararao Jujjuri <jvrao@linux.vnet.ibm.com>
+Venu Byravarasu <vbyravarasu@nvidia.com>
+Vernon Sauder <vernoninhand@gmail.com>
<VernonInHand@gmail.com>
+Vesa-Matti Kari <vmkari@cc.helsinki.fi>
+Vibi Sreenivasan <vibi_sreenivasan@cms.com>
+Vicente Jimenez Aguilar <googuy@gmail.com>
+Victor Vengerov <victor.vengerov@oktetlabs.ru>
<Victor.Vengerov@oktetlabs.ru>
+Vignesh Babu <vignesh.babu@wipro.com>
+Vijay Chauhan <vijay.chauhan@lsi.com>                   <Vijay.Chauhan@lsi.com>
+Vijay Chauhan <vijay.chauhan@netapp.com>
<Vijay.Chauhan@netapp.com>
+Vikram Dhillon <dhillonv10@gmail.com>
<opensolarisdev@gmail.com>
+Vikram Pandita <vikram.pandita@ti.com>
+Viktor Danilov <__die@mail.ru>
+Ville Syrjälä <syrjala@sci.fi>
+Vimal Singh <vimalsingh@ti.com>
+Vinay Hegde <vinay.hegde@ti.com>
+Vincent Cuissard <vincent.cuissard@gmail.com>
+Vincent Sanders <vince@kyllikki.org>                    <vince@org.rmk.(none)>
+Vinod Koul <vinod.koul@intel.com>
+Vinod Koul <vinod.koul@intel.com>
<vinod.koul@linux.intel.com>
+Viral Mehta <viral.mehta@lntinfotech.com>
<Viral.Mehta@lntinfotech.com>
+Viresh Kumar <viresh.kumar@st.com>
+Vishwanath Sripathy <vishwanath.bs@ti.com>
+Vitaly Wool <vwool@ru.mvista.com>                       <vwool@com.rmk.(none)>
+Vladimir Ananiev <vovan888@gmail.com>
+Vladimir Lavallade <erus.iluvatar@gmail.com>
+Vladimir Saveliev <vs@namesys.com>
+Vladimir Sokolovsky <vlad@dev.mellanox.co.il>           <vlad@mellanox.co.il>
+Vladislav Yasevich <vladislav.yasevich@hp.com>
+Vladislav Yasevich <vladislav.yasevich@hp.com>
<vladsilav.yasevich@hp.com>
+Volodymyr G. Lukiianyk <volodymyrgl@gmail.com>
+
+### W #####
+Wai Yew Chay <wychay@ctl.creative.com>
+Walter Gruczka <walter.t.gruczka@boeing.com>
+Walter Harms <wharms@bfs.de>
+Wang Cong <xiyou.wangcong@gmail.com>
+Wang Lei <wang840925@gmail.com>
+Wang Xiaochen <wangxiaochen0@gmail.com>
+Wang YanQing <udknight@gmail.com>
+Wan ZongShun <mcuos.com@gmail.com>
+Wan ZongShun <mcuos.com@gmail.com>                      <mucos.com@gmail.com>
+Wei Dong <weidong@cn.fujitsu.com>
<weid@np.css.fujitsu.com>
+Weidong Han <weidong.han@intel.com>
+Wei Ni <wei.ni@uli.com.tw>                              <Wei.Ni@uli.com.tw>
+Wei Wang <wei_wang@realsil.com.cn>
+Wei Yang <wei.y.yang@intel.com>
+Wei Yongjun <yjwei@cn.fujitsu.com>
<weiyj@soft.fujitsu.com>
+Wei Xing <weixing@hanwang.com.cn>
+Wendy Cheng <wcheng@redhat.com>
+Wendy Xiong <wendyx@us.ibm.com>
+Wengang Wang <wen.gang.wang@oracle.com>
+Werner Fink <werner@suse.de>
+Willem Riede <osst@riede.org>                           <wrlk@riede.org>
+William Jordan <william.jordan@unisys.com>
<William.Jordan@unisys.com>
+Will Schmidt <will_schmidt@vnet.ibm.com>
+Wolfgang Mües <wolfgang.mues@auerswald.de>
+Wolke Liu <wolke.liu@amd.com>                           <Wolke.Liu@amd.com>
+Woogyom Kim <milo.kim@ti.com>
+Woogyom Kim <milo.kim@ti.com>                           <Milo.Kim@ti.com>
+Woogyom Kim <milo.kim@nsc.com>                          <Milo.Kim@nsc.com>
+Wu Guoxing <b39297@freescale.com>
+Wu Jiajun <b06378@freescale.com>                        <B06378@freescale.com>
+Wu Zhangjin <wuzhangjin@gmail.com>
+Wzt <wzt.wzt@gmail.com>
+
+### X #####
+Xiaolan Huang <xiaolan.huang@intel.com>
+Xiaoliang Wei <davidwei79@gmail.com>
+Xiaolong Chen <a21785@motorola.com>
+Xiaoming Zhang <xiaoming.zhang@resilience.com>
<Xiaoming.Zhang@resilience.com>
+Xiaotian Feng <xiaotian.feng@windriver.com>
<Xiaotian.Feng@windriver.com>
+Xiaowei Hu <xiaowei.hu@oracle.com>
+Xingchao Wamg <xingchao.wang@intel.com>
+Xin Li <xin.b.li@intel.com>
+Xudong Hao <xudong.hao@intel.com>
+Xu Lei <B33228@freescale.com>
+
+### Y #####
+Yakui Zhao <yakui.zhao@intel.com>
+Yang Bai <hamo.by@gmail.com>
+Yang Honggang <eagle.rtlinux@gmail.com>
+Yaniv Rosner <yanivr@broadcom.com>
<yaniv.rosner@broadcom.com>
+Yann Morin <yann.morin.1998@anciens.enib.fr>
+Yanmin Zhang <yanmin.zhang@intel.com>
+Yanmin Zhang <yanmin.zhang@intel.com>
<yanmin.zhang@linux.intel.com>
+Yanmin Zhang <yanmin.zhang@intel.com>
<yanmin_zhang@linux.intel.com>
+Yanqing Liu <yanqing_liu@dell.com>                      <Yanqing_Liu@Dell.com>
+Yaozu Dong <eddie.dong@intel.com>
+Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
<yasuyuki.kozkaai@toshiba.co.jp>
+Yeasah Pell <yeasah@schwide.com>                        <yeasah@schwide.net>
+Yehuda Sadeh <yehuda.sadeh@expand.com>
<Yehuda.Sadeh@expand.com>
+Yehuda Sadeh <yehuda@newdream.net>
<yehuda@hq.newdream.net>
+YiCheng Doe <yicheng.doe@hp.com>
+Ying-Chun Liu <paul.liu@linaro.org>
+Yinghai Lu <yinghai.lu@sun.com>                         <Yinghai.Lu@Sun.COM>
+Yinghai Lu <yinghai.lu@amd.com>                         <yinghai@amd.com>
+Ying Huang <ying.huang@intel.com>
+Yin Kangkai <kangkai.yin@linux.intel.com>               <kangkai.yin@intel.com>
+Yi Yang <yi.y.yang@intel.com>
+Yi Zhu <yi.zhu@intel.com>
+Yi Zhu <yi.zhu@intel.com>
<chuyee@debian.sh.intel.com>
+Yoann Di-Ruzza <y.diruzza@lim.eu>
+Yong Wang <yong.y.wang@linux.intel.com>                 <yong.y.wang@intel.com>
+Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
+Yoshihito Takada <takada@mbf.nifty.com>
+Yossi Etigin <yosefe@voltaire.com>                      <root@voltaire.com>
+Yossi Etigin <yosefe@voltaire.com>                      <yosefe@Voltaire.COM>
+Youquan Song <youquan.song@intel.com>
+Youquan Song <youquan.song@intel.com>
<youquan.song@linux.intel.com>
+Yuan-Bo Ye <yuan-bo.ye@motorola.com>
+Yuan-Bo Ye <janboe.ye@gmail.com>
+Yuanhan Liu <yuanhan.liu@intel.com>
<yuanhan.liu@linux.intel.com>
+Yuan Mu <ymu@winbond.com.tw>                            <Ymu@winbond.com.tw>
+Yu-Chen Cho <acho@novell.com>
+Yu-Chen Cho <acho@suse.com>
+Yu Liu <yu.liu@freescale.com>
+Yu Luming <luming.yu@intel.com>
 Yusuke Goda <goda.yusuke@renesas.com>
+Yusuke Goda <goda.yusuke@renesas.com>
<yusuke.goda.sx@renesas.com>
+Yu Xiangliang <yuxiangl@marvell.com>
+Yu Zhao <yu.zhao@intel.com>
+
+### Z #####
+Zaur Kambarov <kambarov@berkeley.edu>
+Zebediah McClure <zmc@lurian.net>
+Zeng Zhaoming <zhaoming.zeng@freescale.com>             <b32542@freescale.com>
+Zephaniah Hull <warp@aehallh.com>
+Zhangfei Gao <zhangfei.gao@marvell.com>                 <zgao6@marvell.com>
+Zhang Xiantao <xiantao.zhang@intel.com>
+Zheng Yan <zheng.z.yan@intel.com>
+Zhao Lei <zhaolei@cn.fujitsu.com>
+Zhao Zhang <zhzhl555@gmail.com>
+Zhe Jiang <zhe.jiang@intel.com>
+Zheng Yan <zheng.z.yan@intel.com>
<zheng.z.yan@linux.intel.com>
+Zheng Zhijian <zheng.zhijian@zte.com.cn>
+Zhenwen Xu <helight.xu@gmail.com>
+Zhenyu Wang <zhenyu.z.wang@intel.com>
+Zhenyu Wang <zhenyu.z.wang@intel.com>
<zhenyuw@linux.intel.com>
+Zhiwu Song <zhiwu.song@csr.com>                         <Zhiwu.Song@csr.com>
+Zhu Yanhai <zhu.yanhai@gmail.com>
